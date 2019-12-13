const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

//Now we're going to create a function that listens to when a 'Notifications' node changes and send a notificcation
//to all devices subscribed to a topic

exports.sendNotification = functions.database
  .ref("leaves/{uid}/{key}")
  .onUpdate((change, context) => {
    //This will be the notification model that we push to firebase

    const before = change.before; // DataSnapshot before the change
    const after = change.after;

    console.log(context.params.uid);

    var request = after.val();

    const payload = {
      notification: {
        title: "Update on your Leave Status",
        body: `Your Leave has been ${request.status}.`
        // icon: follower.photoURL
      },
      data: {
        sound: "default",
        click_action: "FLUTTER_NOTIFICATION_CLICK"
      }
    };

    if (request.withdrawalStatus === 0) {
      var token;
      admin
        .database()
        .ref("users/" + context.params.uid + "/notificationToken")
        .once("value")
        .then(allToken => {
          if (allToken.val()) {
            console.log("token available");
            console.log("Token ID: " + allToken.val());

            setTimeout(() => {
              admin
                .messaging()
                .sendToDevice(allToken.val(), payload)
                .then(response => {
                  console.log("Token " + token);
                  console.log("Successfully sent message: ", response);
                  return true;
                })
                .catch(error => {
                  console.log("Error sending message: ", error);
                  return false;
                });
            }, 2000);
          } else {
            console.log("No token available");
          }
          return true;
        })
        .catch(error => {
          console.log(error);
          return false;
        });
    }
    //The topic variable can be anything from a username, to a uid
    //I find this approach much better than using the refresh token
    //as you can subscribe to someone's phone number, username, or some other unique identifier
    //to communicate between

    //Now let's move onto the code, but before that, let's push this to firebase
  });
//And this is it for building notifications to multiple devices from or to one.
