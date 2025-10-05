///
//  Generated code. Do not modify.
//  source: api2.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'api2.pb.dart' as $0;
export 'api2.pb.dart';

class API2Client extends $grpc.Client {
  static final _$bidirectionalStream =
      $grpc.ClientMethod<$0.Request, $0.Response>(
          '/api2.API2/bidirectionalStream',
          ($0.Request value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$pushStream =
      $grpc.ClientMethod<$0.PushRequest, $0.PushResponse>(
          '/api2.API2/pushStream',
          ($0.PushRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.PushResponse.fromBuffer(value));

  API2Client($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseStream<$0.Response> bidirectionalStream(
      $async.Stream<$0.Request> request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$bidirectionalStream, request, options: options);
    return $grpc.ResponseStream(call);
  }

  $grpc.ResponseStream<$0.PushResponse> pushStream(
      $async.Stream<$0.PushRequest> request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$pushStream, request, options: options);
    return $grpc.ResponseStream(call);
  }
}

abstract class API2ServiceBase extends $grpc.Service {
  $core.String get $name => 'api2.API2';

  API2ServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Request, $0.Response>(
        'bidirectionalStream',
        bidirectionalStream,
        true,
        true,
        ($core.List<$core.int> value) => $0.Request.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PushRequest, $0.PushResponse>(
        'pushStream',
        pushStream,
        true,
        true,
        ($core.List<$core.int> value) => $0.PushRequest.fromBuffer(value),
        ($0.PushResponse value) => value.writeToBuffer()));
  }

  $async.Stream<$0.Response> bidirectionalStream(
      $grpc.ServiceCall call, $async.Stream<$0.Request> request);
  $async.Stream<$0.PushResponse> pushStream(
      $grpc.ServiceCall call, $async.Stream<$0.PushRequest> request);
}
