class Talenta {
  List<Data>? data;

  Talenta({this.data});

  Talenta.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? type;
  Attributes? attributes;

  Data({this.id, this.type, this.attributes});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null ? Attributes.fromJson(json['attributes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    return data;
  }
}

class Attributes {
  int? id;
  String? organisationId;
  int? organisationUserId;
  String? idEmployee;
  String? fullName;
  String? branchName;
  String? jobPosition;
  String? organization;
  String? jobLevel;
  bool? overtimeStatus;
  String? employeeStatus;
  String? officeHourName;
  String? scheduleDate;
  String? attendanceCode;
  String? clockinTime;
  String? clockoutTime;
  bool? holiday;
  bool? useGracePeriod;
  int? clockInDispensationDuration;
  int? clockOutDispensationDuration;
  int? attendanceOfficeHourId;
  int? lateIn;
  int? earlyOut;
  String? avatar;
  String? workStart;
  String? workEnd;
  String? clockIn;
  String? clockOut;
  String? recessStart;
  String? recessEnd;
  String? breakCheckin;
  String? breakCheckout;

  Attributes(
      {this.id,
      this.organisationId,
      this.organisationUserId,
      this.idEmployee,
      this.fullName,
      this.branchName,
      this.jobPosition,
      this.organization,
      this.jobLevel,
      this.overtimeStatus,
      this.employeeStatus,
      this.officeHourName,
      this.scheduleDate,
      this.attendanceCode,
      this.clockinTime,
      this.clockoutTime,
      this.holiday,
      this.useGracePeriod,
      this.clockInDispensationDuration,
      this.clockOutDispensationDuration,
      this.attendanceOfficeHourId,
      this.lateIn,
      this.earlyOut,
      this.avatar,
      this.workStart,
      this.workEnd,
      this.clockIn,
      this.clockOut,
      this.recessStart,
      this.recessEnd,
      this.breakCheckin,
      this.breakCheckout});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organisationId = json['organisation_id'];
    organisationUserId = json['organisation_user_id'];
    idEmployee = json['id_employee'];
    fullName = json['full_name'];
    branchName = json['branch_name'];
    jobPosition = json['job_position'];
    organization = json['organization'];
    jobLevel = json['job_level'];
    overtimeStatus = json['overtime_status'];
    employeeStatus = json['employee_status'];
    officeHourName = json['office_hour_name'];
    scheduleDate = json['schedule_date'];
    attendanceCode = json['attendance_code'];
    clockinTime = json['clockin_time'];
    clockoutTime = json['clockout_time'];
    holiday = json['holiday'];
    useGracePeriod = json['use_grace_period'];
    clockInDispensationDuration = json['clock_in_dispensation_duration'];
    clockOutDispensationDuration = json['clock_out_dispensation_duration'];
    attendanceOfficeHourId = json['attendance_office_hour_id'];
    lateIn = json['late_in'];
    earlyOut = json['early_out'];
    avatar = json['avatar'];
    workStart = json['work_start'];
    workEnd = json['work_end'];
    clockIn = json['clock_in'];
    clockOut = json['clock_out'];
    recessStart = json['recess_start'];
    recessEnd = json['recess_end'];
    breakCheckin = json['break_checkin'];
    breakCheckout = json['break_checkout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['organisation_id'] = organisationId;
    data['organisation_user_id'] = organisationUserId;
    data['id_employee'] = idEmployee;
    data['full_name'] = fullName;
    data['branch_name'] = branchName;
    data['job_position'] = jobPosition;
    data['organization'] = organization;
    data['job_level'] = jobLevel;
    data['overtime_status'] = overtimeStatus;
    data['employee_status'] = employeeStatus;
    data['office_hour_name'] = officeHourName;
    data['schedule_date'] = scheduleDate;
    data['attendance_code'] = attendanceCode;
    data['clockin_time'] = clockinTime;
    data['clockout_time'] = clockoutTime;
    data['holiday'] = holiday;
    data['use_grace_period'] = useGracePeriod;
    data['clock_in_dispensation_duration'] = clockInDispensationDuration;
    data['clock_out_dispensation_duration'] = clockOutDispensationDuration;
    data['attendance_office_hour_id'] = attendanceOfficeHourId;
    data['late_in'] = lateIn;
    data['early_out'] = earlyOut;
    data['avatar'] = avatar;
    data['work_start'] = workStart;
    data['work_end'] = workEnd;
    data['clock_in'] = clockIn;
    data['clock_out'] = clockOut;
    data['recess_start'] = recessStart;
    data['recess_end'] = recessEnd;
    data['break_checkin'] = breakCheckin;
    data['break_checkout'] = breakCheckout;
    return data;
  }
}
