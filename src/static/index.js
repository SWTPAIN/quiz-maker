// pull in desired CSS/SASS files
require( './styles/main.scss' );
require('bulma/css/bulma.css');
const Elm = require( '../elm/Main' );

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
const addQuiz = successCB => quiz => {
  const newQuizRef = quizzesRef.push(); // create auto-generated id
  newQuizRef // create auto-generated id
    .set(quiz)
    .then(() => {
      // no result return from FS even it's successful
      successCB({
        ok: {
          id: newQuizRef.key,
          ...quiz
        },
        err: null
      });
    });
};

const removeLoader = () => {
  const loader = document.getElementsByClassName('loader')[0];
  loader && loader.remove();
};

const bootstrap = ({elemId, flags}) => {
  removeLoader();
  const app = Elm.Main.embed( document.getElementById(elemId), flags );
  app.ports.addQuiz.subscribe(addQuiz(app.ports.addQuizResult.send));
  app.ports.alert.subscribe(msg => window.alert(msg));
};

database.ref('quizzes/')
  .once('value')
  .then(snapshot => {
    const quizzesMap = snapshot.val();
    const quizzes = [];
    for (let id in quizzesMap) {
      if (Object.prototype.hasOwnProperty.call(quizzesMap, id)) {
        quizzes.push({
          id,
          ...quizzesMap[id]
        });
      }
    }
    // const quizzes = Object.values(snapshot.val()) || [];
    bootstrap({elemId: 'main', flags: {quizzes}});
  });
