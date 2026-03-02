import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nursify/BottomNavBar/Patients/patient-model.dart';
import 'package:nursify/cubit/patient-state.dart';

class PatientCubit extends Cubit<PatientState> {
  PatientCubit() : super(PatientState(patients: []));

  void addPatient(PatientModel patient) {
    final updatedPatients = List<PatientModel>.from(state.patients)
      ..add(patient);
    emit(PatientState(patients: updatedPatients));
  }

  void removePatient(PatientModel patient) {
    final updatedPatients = List<PatientModel>.from(state.patients)
      ..remove(patient);
    emit(PatientState(patients: updatedPatients));
  }

  void updatePatient(PatientModel oldPatient, PatientModel newPatient) {
    final updatedPatients = List<PatientModel>.from(state.patients);

    final index = updatedPatients.indexWhere(
      (p) =>
          p.name == oldPatient.name &&
          p.room == oldPatient.room &&
          p.status == oldPatient.status,
    );

    if (index != -1) {
      updatedPatients[index] = newPatient;
      emit(PatientState(patients: updatedPatients));
    }
  }
}
