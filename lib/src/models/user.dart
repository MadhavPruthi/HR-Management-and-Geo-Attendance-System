import 'package:firebase_database/firebase_database.dart';

import 'office.dart';

enum Gender { Male, Female, Other }

enum SkillCategory {
//  TODO
  Unskilled,
  Skilled
}

enum EmployeeFunction {
  // TODO
  ADD_HERE
}

enum EmployeeSubFunction {
  // TODO
  ADD_HERE
}

enum Grade {
  // TODO
  ADD_HERE
}

// Designation is a String, so no enum needed unless specific values are enforced
// enum Designation {
//   // TODO
//   ADD_HERE
// }

enum Nationality {
  Afghan,
  Albanian,
  Algerian,
  American,
  Andorran,
  Angolan,
  Antiguans,
  Argentinean,
  Armenian,
  Australian,
  Austrian,
  Azerbaijani,
  Bahamian,
  Bahraini,
  Bangladeshi,
  Barbadian,
  Barbudans,
  Batswana,
  Belarusian,
  Belgian,
  Belizean,
  Beninese,
  Bhutanese,
  Bolivian,
  Bosnian,
  Brazilian,
  British,
  Bruneian,
  Bulgarian,
  Burkinabe,
  Burmese,
  Burundian,
  Cambodian,
  Cameroonian,
  Canadian,
  Cape,
  Verdean,
  Central_African,
  Chadian,
  Chilean,
  Chinese,
  Colombian,
  Comoran,
  Congolese,
  Costa_Rican,
  Croatian,
  Cuban,
  Cypriot,
  Czech,
  Danish,
  Djibouti,
  Dominican,
  Dutch,
  East_Timorese,
  Ecuadorean,
  Egyptian,
  Emirian,
  Equatorial_Guinean,
  Eritrean,
  Estonian,
  Ethiopian,
  Fijian,
  Filipino,
  Finnish,
  French,
  Gabonese,
  Gambian,
  Georgian,
  German,
  Ghanaian,
  Greek,
  Grenadian,
  Guatemalan,
  Guinea_Bissauan,
  Guinean,
  Guyanese,
  Haitian,
  Herzegovinian,
  Honduran,
  Hungarian,
  I_Kiribati,
  Icelander,
  Indian,
  Indonesian,
  Iranian,
  Iraqi,
  Irish,
  Israeli,
  Italian,
  Ivorian,
  Jamaican,
  Japanese,
  Jordanian,
  Kazakhstani,
  Kenyan,
  Kittian_and_Nevisian,
  Kuwaiti,
  Kyrgyz,
  Laotian,
  Latvian,
  Lebanese,
  Liberian,
  Libyan,
  Liechtensteiner,
  Lithuanian,
  Luxembourger,
  Macedonian,
  Malagasy,
  Malawian,
  Malaysian,
  Maldivian,
  Malian,
  Maltese,
  Marshallese,
  Mauritanian,
  Mauritian,
  Mexican,
  Micronesian,
  Moldovan,
  Monacan,
  Mongolian,
  Moroccan,
  Mosotho,
  Motswana,
  Mozambican,
  Namibian,
  Nauruan,
  Nepalese,
  New_Zealander,
  Ni_Vanuatu,
  Nicaraguan,
  Nigerian,
  Nigerien,
  North_Korean,
  Northern_Irish,
  Norwegian,
  Omani,
  Pakistani,
  Palauan,
  Panamanian,
  Papua_New_Guinean,
  Paraguayan,
  Peruvian,
  Polish,
  Portuguese,
  Qatari,
  Romanian,
  Russian,
  Rwandan,
  Saint_Lucian,
  Salvadoran,
  Samoan,
  San_Marinese,
  Sao_Tomean,
  Saudi,
  Scottish,
  Senegalese,
  Serbian,
  Seychellois,
  Sierra_Leonean,
  Singaporean,
  Slovakian,
  Slovenian,
  Solomon_Islander,
  Somali,
  South_African,
  South_Korean,
  Spanish,
  Sri_Lankan,
  Sudanese,
  Surinamer,
  Swazi,
  Swedish,
  Swiss,
  Syrian,
  Taiwanese,
  Tajik,
  Tanzanian,
  Thai,
  Togolese,
  Tongan,
  Trinidadian_or_Tobagonian,
  Tunisian,
  Turkish,
  Tuvaluan,
  Ugandan,
  Ukrainian,
  Uruguayan,
  Uzbekistani,
  Venezuelan,
  Vietnamese,
  Welsh,
  Yemenite,
  Zambian,
  Zimbabwean
}

enum MaritalStatus {
  Unmarried,
  Married,
  ItsComplicated, // Note: Original enum had "It's Complicated" which is not a valid Dart enum value name
}

enum Religion {
  African_Traditional,
  Agnostic,
  Atheist,
  Bahai,
  Buddhism,
  Cao_Dai,
  Chinese_traditional_religion,
  Christianity,
  Hinduism,
  Islam,
  Jainism,
  Juche,
  Judaism,
  Neo_Paganism,
  Non_religious,
  Rastafarianism,
  Secular,
  Shinto,
  Sikhism,
  Spiritism,
  Tenrikyo,
  Unitarian_Universalism,
  Zoroastrianism,
  Primal_indigenous,
  Other
}

enum Entity {
  //TODO
  ADD_HERE
}

enum BloodGroup {
  A_positive,
  A_negative,
  B_positive,
  B_negative,
  AB_positive,
  O_positive,
  O_negative
}

enum EmployeeType { Trainee, Manager }

enum Role {
  // TODO
  ADD_HERE
}

class Employee {
  String? uID; // Made nullable as it might not always be present directly in snapshot.value
  String? employeeID;
  String? firstName;
  String? middleName;
  String? lastName;
  String? officeEmail;
  String? alternateEmail;
  String? contactNumber;
  DateTime? dateOfBirth;
  DateTime? joiningDate;
  String? residentialAddress;
  Gender? gender;
  int? retirementAge;

  Office? joiningUnit;
  SkillCategory? skillCategory;

  EmployeeFunction? employeeFunction;
  EmployeeSubFunction? employeeSubFunction;

  Grade? grade;
  String? designation;

  MaritalStatus? maritalStatus;
  Religion? religion;

  Nationality? nationality;

  Entity? entity;
  BloodGroup? bloodGroup;

  EmployeeType? employeeType;
  Employee? reviewPerson;

  Role? role;

  Employee(
      {this.uID, // Added uID to constructor
      this.employeeID,
      this.firstName,
      this.middleName,
      this.lastName,
      this.residentialAddress,
      this.contactNumber,
      this.officeEmail,
      this.alternateEmail,
      this.dateOfBirth,
      this.joiningDate,
      this.gender,
      this.retirementAge,
      this.joiningUnit,
      this.skillCategory,
      this.employeeFunction,
      this.employeeSubFunction,
      this.grade,
      this.designation,
      this.maritalStatus,
      this.religion,
      this.nationality,
      this.entity,
      this.bloodGroup,
      this.employeeType,
      this.reviewPerson,
      this.role});

  Employee.fromSnapshot(DataSnapshot snapshot)
      : uID = snapshot.value["UID"],
        employeeID = snapshot.value["employeeID"],
        firstName = snapshot.value["firstName"],
        middleName = snapshot.value["middleName"],
        lastName = snapshot.value["lastName"],
        officeEmail = snapshot.value["officeEmail"],
        alternateEmail = snapshot.value["alternateEmail"],
        contactNumber = snapshot.value["contactNumber"],
        dateOfBirth = _parseDateTime(snapshot.value["dateOfBirth"]),
        joiningDate = _parseDateTime(snapshot.value["joiningDate"]),
        residentialAddress = snapshot.value["residentialAddress"],
        gender = _parseGender(snapshot.value["gender"]),
        retirementAge = snapshot.value["retirementAge"],
        joiningUnit = snapshot.value["joiningUnit"] != null && snapshot.value["joiningUnit"] is Map
            ? Office.fromJson(snapshot.value["joiningUnit"]["key"] ?? snapshot.key, Map<String,dynamic>.from(snapshot.value["joiningUnit"]))
            : null,
        skillCategory = _parseSkillCategory(snapshot.value["skillCategory"]),
        employeeFunction = _parseEmployeeFunction(snapshot.value["employeeFunction"]),
        employeeSubFunction = _parseEmployeeSubFunction(snapshot.value["employeeSubFunction"]),
        grade = _parseGrade(snapshot.value["grade"]),
        designation = snapshot.value["designation"],
        maritalStatus = _parseMaritalStatus(snapshot.value["maritalStatus"]),
        religion = _parseReligion(snapshot.value["religion"]),
        nationality = _parseNationality(snapshot.value["nationality"]),
        entity = _parseEntity(snapshot.value["entity"]),
        bloodGroup = _parseBloodGroup(snapshot.value["bloodGroup"]),
        employeeType = _parseEmployeeType(snapshot.value["employeeType"]),
        reviewPerson = null, // Simplified for now, would require recursive parsing or ID-based fetching
        role = _parseRole(snapshot.value["role"]);

  Map<String, dynamic> toJson() { // Made types nullable to match class fields
    return {
      "UID": uID,
      "employeeID": employeeID,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "officeEmail": officeEmail,
      "alternateEmail": alternateEmail,
      "contactNumber": contactNumber,
      "dateOfBirth": dateOfBirth?.toIso8601String(), // Convert DateTime to ISO string
      "joiningDate": joiningDate?.toIso8601String(), // Convert DateTime to ISO string
      "residentialAddress": residentialAddress,
      "gender": gender?.toString(), // Convert Enum to string
      "retirementAge": retirementAge,
      "joiningUnit": joiningUnit?.toJson(), // Assuming Office has a toJson method
      "skillCategory": skillCategory?.toString(),
      "employeeFunction": employeeFunction?.toString(),
      "employeeSubFunction": employeeSubFunction?.toString(),
      "grade": grade?.toString(),
      "designation": designation,
      "maritalStatus": maritalStatus?.toString(),
      "religion": religion?.toString(),
      "nationality": nationality?.toString(),
      "entity": entity?.toString(),
      "bloodGroup": bloodGroup?.toString(),
      "employeeType": employeeType?.toString(),
      "reviewPerson": reviewPerson?.toJson(), // Assuming Employee has toJson for nested obj
      "role": role?.toString(),
    };
  }
}

// Helper functions

DateTime? _parseDateTime(String? dateStr) {
    if (dateStr == null) return null;
    try {
        return DateTime.parse(dateStr);
    } catch (e) {
        print('Error parsing DateTime: $dateStr, Error: $e'); // Log error
        return null;
    }
}

Gender _parseGender(String? genderStr) {
  if (genderStr == null) return Gender.Other;
  return Gender.values.firstWhere((e) => e.toString() == genderStr, orElse: () => Gender.Other);
}

SkillCategory _parseSkillCategory(String? skillStr) {
  if (skillStr == null) return SkillCategory.Unskilled; // Default as per original enum
  return SkillCategory.values.firstWhere((e) => e.toString() == skillStr, orElse: () => SkillCategory.Unskilled);
}

EmployeeFunction _parseEmployeeFunction(String? str) {
  if (str == null) return EmployeeFunction.ADD_HERE;
  return EmployeeFunction.values.firstWhere((e) => e.toString() == str, orElse: () => EmployeeFunction.ADD_HERE);
}

EmployeeSubFunction _parseEmployeeSubFunction(String? str) {
  if (str == null) return EmployeeSubFunction.ADD_HERE;
  return EmployeeSubFunction.values.firstWhere((e) => e.toString() == str, orElse: () => EmployeeSubFunction.ADD_HERE);
}

Grade _parseGrade(String? str) {
  if (str == null) return Grade.ADD_HERE;
  return Grade.values.firstWhere((e) => e.toString() == str, orElse: () => Grade.ADD_HERE);
}

MaritalStatus _parseMaritalStatus(String? statusStr) {
  if (statusStr == null) return MaritalStatus.Unmarried;
  return MaritalStatus.values.firstWhere((e) => e.toString() == statusStr, orElse: () => MaritalStatus.Unmarried);
}

Religion _parseReligion(String? religionStr) {
  if (religionStr == null) return Religion.Other;
  return Religion.values.firstWhere((e) => e.toString() == religionStr, orElse: () => Religion.Other);
}

Nationality _parseNationality(String? nationStr) {
  if (nationStr == null) return Nationality.Indian;
  return Nationality.values.firstWhere((e) => e.toString() == nationStr, orElse: () => Nationality.Indian);
}

Entity _parseEntity(String? str) {
  if (str == null) return Entity.ADD_HERE;
  return Entity.values.firstWhere((e) => e.toString() == str, orElse: () => Entity.ADD_HERE);
}

BloodGroup _parseBloodGroup(String? bloodGroupStr) {
  if (bloodGroupStr == null) return BloodGroup.O_positive;
  return BloodGroup.values.firstWhere((e) => e.toString() == bloodGroupStr, orElse: () => BloodGroup.O_positive);
}

EmployeeType _parseEmployeeType(String? typeStr) {
  if (typeStr == null) return EmployeeType.Trainee;
  return EmployeeType.values.firstWhere((e) => e.toString() == typeStr, orElse: () => EmployeeType.Trainee);
}

Role _parseRole(String? str) {
  if (str == null) return Role.ADD_HERE;
  return Role.values.firstWhere((e) => e.toString() == str, orElse: () => Role.ADD_HERE);
}
