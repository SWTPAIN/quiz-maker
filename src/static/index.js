// pull in desired CSS/SASS files
require( './styles/main.scss' );
require('bulma/css/bulma.css');
var Elm = require( '../elm/Main' );

const firebase = require('firebase');
const config = {
  apiKey: 'AIzaSyBm20vlcZGc7VSGTz4M7CwvMfkB1Pf9FyE',
  authDomain: 'quiz-maker-3cbbb.firebaseapp.com',
  databaseURL: 'https://quiz-maker-3cbbb.firebaseio.com',
  projectId: 'quiz-maker-3cbbb',
  storageBucket: '',
  messagingSenderId: '1029729243261'
};
firebase.initializeApp(config);
const database = firebase.database();
const quizzesRef = database.ref('quizzes/');
const addQuiz = quiz => {
  quizzesRef
    .push() // create auto-generated id
    .set(quiz);
};

const bootstrap = ({elemId, flags}) => {
  const app = Elm.Main.embed( document.getElementById(elemId), flags );
  app.ports.addQuiz.subscribe(addQuiz);
};
database.ref('quizzes/')
  .once('value')
  .then(snapshot => {
    const quizzes = Object.values(snapshot.val()) || [];
    bootstrap({elemId: 'main', flags: {quizzes}});
  });
