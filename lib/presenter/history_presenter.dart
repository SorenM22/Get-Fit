import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctrl_alt_defeat/models/user_repository.dart';
import 'package:get/get.dart';

class HistoryPresenter {
  Future<String?> getUserID() async {
    final userRepo = Get.put(UserRepository());
    return userRepo.getCurrentUserUID();
  }

  Future<List<String>> getWorkoutIds() async {
    final userData = FirebaseFirestore.instance.collection('User_Data');
    final workouts = userData.doc(await getUserID()).collection("Workout_Data");

    List<String> workoutList = [];

    await workouts.get().then(
            (workoutQuerySnapshot) {
          for(var workoutDocSnapshot in workoutQuerySnapshot.docs) {
            workoutList.add(workoutDocSnapshot.id);
          }
        }
    );

    return workoutList;
  }

  Future<List<String>> getExercises(String workoutId) async {
    final userRepo = Get.put(UserRepository());
    String? userID = userRepo.getCurrentUserUID();
    final userData = FirebaseFirestore.instance.collection('User_Data');
    final workouts = userData.doc(userID).collection("Workout_Data");

    List<String> exerciseList = [];

    await workouts.doc(workoutId).collection('Exercises').get().then(
        (exerciseQuerySnapshot) {
          for(var exerciseDocSnapshot in exerciseQuerySnapshot.docs) {
            exerciseList.add(exerciseDocSnapshot.id);
          }
        }
    );

    return exerciseList;
  }

  Future<List<List<int>>> getSets(String workoutId, String exerciseName) async {
    final userRepo = Get.put(UserRepository());
    String? userID = userRepo.getCurrentUserUID();
    final userData = FirebaseFirestore.instance.collection('User_Data');
    final workouts = userData.doc(userID).collection("Workout_Data");

    List<List<int>> setList = [];

    await workouts.doc(workoutId).collection('Exercises').doc(exerciseName).collection('Sets').get().then(
            (setQuerySnapshot) {
          for(var setDocSnapshot in setQuerySnapshot.docs) {
            setList.add([setDocSnapshot.data().values.first, setDocSnapshot.data().values.last]);
          }
        }
    );
    return setList;
  }

  void deleteExercise(String workoutId) async {
    final userId = await getUserID();
    FirebaseFirestore.instance.collection('User_Data').doc(userId).collection('Workout_Data').doc(workoutId).delete();
  }
}
