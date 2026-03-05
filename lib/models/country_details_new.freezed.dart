// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CountryDetails {
  String get name => throw _privateConstructorUsedError;
  String get flag => throw _privateConstructorUsedError;
  int get population => throw _privateConstructorUsedError;
  String get capital => throw _privateConstructorUsedError;
  String get region => throw _privateConstructorUsedError;
  String get subregion => throw _privateConstructorUsedError;
  double get area => throw _privateConstructorUsedError;
  List<String> get timezones => throw _privateConstructorUsedError;

  /// Create a copy of CountryDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CountryDetailsCopyWith<CountryDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CountryDetailsCopyWith<$Res> {
  factory $CountryDetailsCopyWith(
    CountryDetails value,
    $Res Function(CountryDetails) then,
  ) = _$CountryDetailsCopyWithImpl<$Res, CountryDetails>;
  @useResult
  $Res call({
    String name,
    String flag,
    int population,
    String capital,
    String region,
    String subregion,
    double area,
    List<String> timezones,
  });
}

/// @nodoc
class _$CountryDetailsCopyWithImpl<$Res, $Val extends CountryDetails>
    implements $CountryDetailsCopyWith<$Res> {
  _$CountryDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CountryDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? flag = null,
    Object? population = null,
    Object? capital = null,
    Object? region = null,
    Object? subregion = null,
    Object? area = null,
    Object? timezones = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            flag: null == flag
                ? _value.flag
                : flag // ignore: cast_nullable_to_non_nullable
                      as String,
            population: null == population
                ? _value.population
                : population // ignore: cast_nullable_to_non_nullable
                      as int,
            capital: null == capital
                ? _value.capital
                : capital // ignore: cast_nullable_to_non_nullable
                      as String,
            region: null == region
                ? _value.region
                : region // ignore: cast_nullable_to_non_nullable
                      as String,
            subregion: null == subregion
                ? _value.subregion
                : subregion // ignore: cast_nullable_to_non_nullable
                      as String,
            area: null == area
                ? _value.area
                : area // ignore: cast_nullable_to_non_nullable
                      as double,
            timezones: null == timezones
                ? _value.timezones
                : timezones // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CountryDetailsImplCopyWith<$Res>
    implements $CountryDetailsCopyWith<$Res> {
  factory _$$CountryDetailsImplCopyWith(
    _$CountryDetailsImpl value,
    $Res Function(_$CountryDetailsImpl) then,
  ) = __$$CountryDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String flag,
    int population,
    String capital,
    String region,
    String subregion,
    double area,
    List<String> timezones,
  });
}

/// @nodoc
class __$$CountryDetailsImplCopyWithImpl<$Res>
    extends _$CountryDetailsCopyWithImpl<$Res, _$CountryDetailsImpl>
    implements _$$CountryDetailsImplCopyWith<$Res> {
  __$$CountryDetailsImplCopyWithImpl(
    _$CountryDetailsImpl _value,
    $Res Function(_$CountryDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CountryDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? flag = null,
    Object? population = null,
    Object? capital = null,
    Object? region = null,
    Object? subregion = null,
    Object? area = null,
    Object? timezones = null,
  }) {
    return _then(
      _$CountryDetailsImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        flag: null == flag
            ? _value.flag
            : flag // ignore: cast_nullable_to_non_nullable
                  as String,
        population: null == population
            ? _value.population
            : population // ignore: cast_nullable_to_non_nullable
                  as int,
        capital: null == capital
            ? _value.capital
            : capital // ignore: cast_nullable_to_non_nullable
                  as String,
        region: null == region
            ? _value.region
            : region // ignore: cast_nullable_to_non_nullable
                  as String,
        subregion: null == subregion
            ? _value.subregion
            : subregion // ignore: cast_nullable_to_non_nullable
                  as String,
        area: null == area
            ? _value.area
            : area // ignore: cast_nullable_to_non_nullable
                  as double,
        timezones: null == timezones
            ? _value._timezones
            : timezones // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$CountryDetailsImpl implements _CountryDetails {
  const _$CountryDetailsImpl({
    required this.name,
    required this.flag,
    required this.population,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.area,
    required final List<String> timezones,
  }) : _timezones = timezones;

  @override
  final String name;
  @override
  final String flag;
  @override
  final int population;
  @override
  final String capital;
  @override
  final String region;
  @override
  final String subregion;
  @override
  final double area;
  final List<String> _timezones;
  @override
  List<String> get timezones {
    if (_timezones is EqualUnmodifiableListView) return _timezones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timezones);
  }

  @override
  String toString() {
    return 'CountryDetails(name: $name, flag: $flag, population: $population, capital: $capital, region: $region, subregion: $subregion, area: $area, timezones: $timezones)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CountryDetailsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.flag, flag) || other.flag == flag) &&
            (identical(other.population, population) ||
                other.population == population) &&
            (identical(other.capital, capital) || other.capital == capital) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.subregion, subregion) ||
                other.subregion == subregion) &&
            (identical(other.area, area) || other.area == area) &&
            const DeepCollectionEquality().equals(
              other._timezones,
              _timezones,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    flag,
    population,
    capital,
    region,
    subregion,
    area,
    const DeepCollectionEquality().hash(_timezones),
  );

  /// Create a copy of CountryDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CountryDetailsImplCopyWith<_$CountryDetailsImpl> get copyWith =>
      __$$CountryDetailsImplCopyWithImpl<_$CountryDetailsImpl>(
        this,
        _$identity,
      );
}

abstract class _CountryDetails implements CountryDetails {
  const factory _CountryDetails({
    required final String name,
    required final String flag,
    required final int population,
    required final String capital,
    required final String region,
    required final String subregion,
    required final double area,
    required final List<String> timezones,
  }) = _$CountryDetailsImpl;

  @override
  String get name;
  @override
  String get flag;
  @override
  int get population;
  @override
  String get capital;
  @override
  String get region;
  @override
  String get subregion;
  @override
  double get area;
  @override
  List<String> get timezones;

  /// Create a copy of CountryDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CountryDetailsImplCopyWith<_$CountryDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
