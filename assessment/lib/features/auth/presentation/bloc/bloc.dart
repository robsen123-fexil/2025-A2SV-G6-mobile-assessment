import 'package:assessment/features/auth/domain/domain_repositories/auth_repositories.dart';
import 'package:assessment/features/auth/presentation/bloc/event.dart';
import 'package:assessment/features/auth/presentation/bloc/state.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent , AuthState> {
  final AuthRepositories authRepository;
AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.register(
        event.name,
        event.email,
        event.password,
      );

      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(
          AuthSuccess(user)
        ),
      );
    });

    
  }


}