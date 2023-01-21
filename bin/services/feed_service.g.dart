// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_service.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$FeedServiceRouter(FeedService service) {
  final router = Router();
  router.add(
    'GET',
    r'/',
    service.viewDefaultFeed,
  );
  router.add(
    'GET',
    r'/<language>/<feed>',
    service.viewFeed,
  );
  return router;
}
