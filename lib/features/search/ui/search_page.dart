import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchPage extends StatefulHookConsumerWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _searchPageState();
}

class _searchPageState extends ConsumerState<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return const Text("Search page");
  }
}