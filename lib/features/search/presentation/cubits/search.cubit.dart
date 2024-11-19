import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_project/features/search/domain/repository/search.repository.dart';
import 'package:flutter_social_project/features/search/presentation/cubits/search.states.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepo;

  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final users = await searchRepo.searchUsers(query);
      emit(SearchLoaded(users));
    } catch (e) {
      emit(SearchError("Error fetching search results"));
    }
  }
}
