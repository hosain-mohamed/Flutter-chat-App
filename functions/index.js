const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.myFunction = functions.firestore
  .document('users/{user_id}/{contacts}/{friend_id}/{messages}/{message_id}')
  .onCreate((snap, context) => {
    // Get an object representing the document
    // e.g. {'name': 'Marie', 'age': 66}
    const newValue = snap.data();
    if(snap.data().senderId === context.params.friend_id){
        console.log(newValue);
    }
    return ;
    // access a particular field as you would any JS property
    //const name = newValue.name;

    // perform desired operations ...
  });