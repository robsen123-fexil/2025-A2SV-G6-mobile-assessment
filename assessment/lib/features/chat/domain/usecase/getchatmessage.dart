import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/usecase/usecase.dart';
import 'package:assessment/features/chat/domain/entities/chat_message.dart';
import 'package:assessment/features/chat/domain/repositories/chat_repositories.dart';
import 'package:dartz/dartz.dart';

class GetChatMessage implements UseCase<List<ChatMessage>, ChatDetailParams> {
  final ChatRepositories chatDetailRepository;
  GetChatMessage({required this.chatDetailRepository});
  
  @override
  Future<Either<Failure, List<ChatMessage>>> call(ChatDetailParams params) {
    return chatDetailRepository.getChatMessage(params.token, params.chatId);
  }

 
}