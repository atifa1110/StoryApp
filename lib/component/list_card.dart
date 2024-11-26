
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/model/story.dart';
import '../routing/app_routes.dart';
import '../routing/extras.dart';
import '../routing/key.dart';

class ListCard extends StatelessWidget {

  final Story data;

  const ListCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      shadowColor: Colors.black12,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            context.pushNamed(
              Routes.detailStory.name,
              extra: Extras(
                extras: {
                  Keys.storyId: data.id,
                },
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Image.network(
                  data.photoUrl??"",
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height:
                  MediaQuery.of(context).size.height *
                      0.2,
                  loadingBuilder:
                      (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Image.asset(
                      "assets/images/placeholder.png",
                      fit: BoxFit.cover,
                    );
                  },
                  errorBuilder:
                      (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name??"",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      data.description??"",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}