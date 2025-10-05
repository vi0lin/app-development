///
//  Generated code. Do not modify.
//  source: api2.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Request extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Request', package: const $pb.PackageName('api2'), createEmptyInstance: create)
    ..aOS(1, 'requestData')
    ..hasRequiredFields = false
  ;

  Request._() : super();
  factory Request() => create();
  factory Request.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Request.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Request clone() => Request()..mergeFromMessage(this);
  Request copyWith(void Function(Request) updates) => super.copyWith((message) => updates(message as Request));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Request create() => Request._();
  Request createEmptyInstance() => create();
  static $pb.PbList<Request> createRepeated() => $pb.PbList<Request>();
  @$core.pragma('dart2js:noInline')
  static Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Request>(create);
  static Request _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestData => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestData($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestData() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestData() => clearField(1);
}

class Response extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Response', package: const $pb.PackageName('api2'), createEmptyInstance: create)
    ..aOS(1, 'responseData')
    ..hasRequiredFields = false
  ;

  Response._() : super();
  factory Response() => create();
  factory Response.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Response.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Response clone() => Response()..mergeFromMessage(this);
  Response copyWith(void Function(Response) updates) => super.copyWith((message) => updates(message as Response));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Response create() => Response._();
  Response createEmptyInstance() => create();
  static $pb.PbList<Response> createRepeated() => $pb.PbList<Response>();
  @$core.pragma('dart2js:noInline')
  static Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Response>(create);
  static Response _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get responseData => $_getSZ(0);
  @$pb.TagNumber(1)
  set responseData($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasResponseData() => $_has(0);
  @$pb.TagNumber(1)
  void clearResponseData() => clearField(1);
}

class PushRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PushRequest', package: const $pb.PackageName('api2'), createEmptyInstance: create)
    ..aOS(1, 'idToken', protoName: 'idToken')
    ..aOS(2, 'message')
    ..hasRequiredFields = false
  ;

  PushRequest._() : super();
  factory PushRequest() => create();
  factory PushRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PushRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PushRequest clone() => PushRequest()..mergeFromMessage(this);
  PushRequest copyWith(void Function(PushRequest) updates) => super.copyWith((message) => updates(message as PushRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PushRequest create() => PushRequest._();
  PushRequest createEmptyInstance() => create();
  static $pb.PbList<PushRequest> createRepeated() => $pb.PbList<PushRequest>();
  @$core.pragma('dart2js:noInline')
  static PushRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushRequest>(create);
  static PushRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set idToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIdToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class PushResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PushResponse', package: const $pb.PackageName('api2'), createEmptyInstance: create)
    ..aOS(1, 'idUser', protoName: 'idUser')
    ..aOS(2, 'message')
    ..hasRequiredFields = false
  ;

  PushResponse._() : super();
  factory PushResponse() => create();
  factory PushResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PushResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PushResponse clone() => PushResponse()..mergeFromMessage(this);
  PushResponse copyWith(void Function(PushResponse) updates) => super.copyWith((message) => updates(message as PushResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PushResponse create() => PushResponse._();
  PushResponse createEmptyInstance() => create();
  static $pb.PbList<PushResponse> createRepeated() => $pb.PbList<PushResponse>();
  @$core.pragma('dart2js:noInline')
  static PushResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushResponse>(create);
  static PushResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idUser => $_getSZ(0);
  @$pb.TagNumber(1)
  set idUser($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIdUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdUser() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

