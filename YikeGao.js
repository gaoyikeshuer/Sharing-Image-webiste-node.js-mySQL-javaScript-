const express = require("express");
const app = express();
const mysql = require("mysql");
var port = 8000;
var bodyParser = require("body-parser");
var session = require("express-session");
var fileUpload = require("express-fileupload");
const { request } = require("http");
const exhbs = require('express-handlebars');
const { fileURLToPath } = require("url");
const { query } = require("express");

const connection = mysql.createConnection({

    host: "localhost",
    user: "root",
    password: "Nm6683317",
    database: "sharingimage"
})
connection.connect(function (error) {
    if (error) console.log("Error connecting to database" + error);
    else console.log("connected to the databse successfully!")
})
app.use(express.static("public"));
app.set("view-engine", "ejs");
app.set("views", "views");
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(fileUpload());
app.use(session({
    secret: "ttgfhrwgedgnl7qtcoqtcg2uyaugyuegeuagu111",
    resave: false,
    saveUninitialized: true,
    cookie: { maxAge: 60000 }
}));

// create the gallery homepage
app.get("/", function (req, res) {
    var sessionUser = req.session.username;
    var sql1 = 'SELECT imageurl, postid, likecount, userid,commentcount FROM posts';
    var sql2 = 'SELECT  likes.postid FROM users JOIN likes ON users.userid = likes.userid  WHERE users.username ="'+sessionUser+'"';
    var sql3 = 'SELECT SUM(likes.likecount) as sum FROM likes JOIN posts ON likes.postid = posts.postid WHERE posts.postid = ? '
    var sql5 = 'SELECT COUNT(comments.commentid) as count FROM comments JOIN posts ON comments.postid = posts.postid WHERE posts.postid = ? '
    connection.query(sql1, function (err, result) {
        var string = JSON.stringify(result);
        var json = JSON.parse(string);
        if (result && result.length) {
          //get each url from database and put them in the page
            const images = [];
            for (const item of json) {
                const img = item.imageurl;
                const id = item.postid;
               
                const userid = item.userid;
                connection.query(sql3,id,function(err,result3){
                var sql4 = 'UPDATE posts SET likecount = "'+ result3[0].sum +'" WHERE postid =' +id;
                  connection.query(sql4,function(err,result4){
                
                  })
                })
                connection.query(sql5,id,function(err,result5){
                    var sql6 = 'UPDATE posts SET commentcount = "'+ result5[0].count +'" WHERE postid =' +id;
                    connection.query(sql6,function(err,result6){})
                })
               //display the counts of comment and likes
                const likecount = item.likecount; 
                const comment = item.commentcount;
                images.push({ img, id, likecount, userid, comment });
            }
            
            if (sessionUser) {
                connection.query(sql2,function(err,result2){
                    
                        var string2 = JSON.stringify(result2);
                        var json2 = JSON.parse(string2);
                        const likes = [];
                        for(const like of json2){
                            const postid = like.postid;
                            likes.push({postid});
                        }
                        res.render("gallery.ejs", {
                            "isLogin": true,
                            "query": req.query,
                            "username": sessionUser,
                           
                             likes,
                            images
                        })
                  
                  
                })
           
               

            
            } else {
                res.render("gallery.ejs", {
                    "isLogin": false,
                    "query": req.query,
                    images

                });
            }


        }
 
    })
})

app.get("/register", function (req, res) {
    res.render("register.ejs", {
        "query": req.query
    });
});
app.post("/register", function (req, res) {
    inputData = {
        username: req.body.username,
        password: req.body.password
    }
    if (req.body.password != req.body.confirm_password) {
        res.redirect("/register?error=mismatch");
    }
    var sql = "SELECT * FROM users WHERE username =? ";
    connection.query(sql, [inputData.username], function (err, data, fields) {
        
        if (data> 0) {
            res.redirect("/register?error=exists"); // if username already exist
        } else {
            var sql = "INSERT INTO users SET ?";
            connection.query(sql, inputData, function (err, data) {
                if (err) throw err;
                res.redirect("/login?message=registered")
            });
            // res.redirect("/login"); // after registration, redirect to login page
        }
    })
});
app.get("/login", function (req, res) {
    res.render("login.ejs", { "query": req.query });
});
app.post("/login", function (req, res) {
    var username = req.body.username;
    var password = req.body.password;
    var sql1 = "select * from users where username = ?";
    var sql2 = "select * from users where password = ?";
    connection.query(sql1, username, function (error, results, fields) {
        if (results.length > 0) {
            connection.query(sql2, password, function (error, results, fields) {
                if (results.length > 0) {
                    req.session.username = username;
                    req.session.password = password;
                    res.redirect("/");
                }
                else {
                    res.redirect("/login?error=wrong_password");
                }
            })

        } else {
            res.redirect("/login?error=not_exists");
        }
    })
});
app.get("/logout", function (req, res) {
    req.session.destroy();
    res.redirect("/");
});
app.get("/my_uploads", function (req, res) {
    if (req.session.username) {
        res.render("uploadimg.ejs", {
            "isLogin": true,
            "query": req.query,
            "username": req.session.username
            
        })
    }else{
        res.render("uploadimg.ejs", {
            "isLogin": false,
            "query": req.query   })
    }
});
app.post('/upload-image', function (req, res) {
    const file = req.files.myimage;

if(req.session.username){
    if (!file) {
        return res.status(400).send({ message: 'Please upload a file' });
    } else {
        file.mv("public/uploads/" + file.name);
        res.redirect("/");
        // res.render("uploads.ejs", { "filename": file.name });
        var imgsrc = 'http://localhost:8000/uploads/' + file.name;
        
        var sql = 'INSERT INTO posts (imageurl, userid) VALUES ( ? , (SELECT userid FROM users WHERE username = "' + req.session.username + '"))'
        connection.query(sql, imgsrc, function (err, data) {
            if (err) throw err;
        });
    }
}
else{
    res.redirect("/my_uploads");
}
 
})


app.get("/view-image", function (req, res) {

    var sql1 = 'SELECT imageurl, userid, posttime FROM posts WHERE postid = ?';
    var sql2 = 'SELECT username FROM users WHERE userid = ?'
    var sql3 = 'SELECT comments.commenttext, comments.commenttime, users.username FROM comments JOIN users ON comments.userid = users.userid WHERE postid = ?'
    connection.query(sql1, req.query.id, function (err, result1) {
        var newPostTime = new Date(result1[0].posttime).toDateString();
        connection.query(sql2, result1[0].userid, function (err, result2) {
            connection.query(sql3,req.query.id,function(err,result3){
                
                const comments = [];
                for (const comment of result3) {
                    const commenttext = comment.commenttext;
                    const commenttime = new Date(comment.commenttime).toLocaleString('en-US',{hour12: false});
                    const commentuser = comment.username;
                    comments.push({ commenttext, commenttime, commentuser });
                }
                if(req.session.username){
              
                    res.render("view-image.ejs", { imageurl: result1[0].imageurl, username: result2[0].username, "isLogin": true,
                    "query": req.query, "postid":req.query.id, "posttime": newPostTime, comments })
                }else{
                    
                    res.render("view-image.ejs", { imageurl: result1[0].imageurl, username: result2[0].username, "isLogin": false,
                    "query": req.query, "postid": req.query.id, "posttime": newPostTime, comments })
                }
            })
       
           
        })


    })
}
)

app.post("/do-comment", function (req, res) {
    var post_id = req.body._id;
    var post_comment = req.body.comment;
    
  
    var sql = 'INSERT INTO comments (commenttext, postid, userid) VALUES ("'+post_comment +'","'+post_id+ '",(SELECT userid FROM users WHERE username = "'+req.session.username +'" ))'
        connection.query(sql,function(err,result){
            if (req.session.username) { 
                res.redirect("/view-image?id="+post_id+"&message=success#comments");
            }
        })
   
})
// add the likes in the database
app.post("/do-like", function(req,res){
    
    if(req.session.username){
        var sql1 = 'SELECT userid FROM users WHERE users.username = "'+ req.session.username+ '"';
       var sql2 = 'INSERT INTO likes SET ?'
    
        connection.query(sql1,function(err,result1){
            inputData ={
                postid: req.body.id,
                userid: result1[0].userid,
                likecount: 1
            }
           
         connection.query(sql2,inputData,function(err,result2){
             res.json({
                 "status": "success",
                 "message": "Image has been liked"
             })
         })
        })
       
    }
})
// cancel the likes in the database
app.post("/dis-like",function(req,res){
    if(req.session.username){
       
        var sql1 = 'SELECT userid FROM users WHERE users.username = "'+ req.session.username+ '"';
        connection.query(sql1,function(err,result1){
          
        var sql2 = 'DELETE FROM likes WHERE likes.userid = "'+ result1[0].userid +'" AND likes.postid = "'+req.body.id + '"';
        connection.query(sql2,function(err,result2){
            
            res.json({
                "status": "success",
                "message": "Like has been deleted"
            })
        })
        })
    }

})


app.listen(port);
console.log("Server running on http://localhost:" + port);