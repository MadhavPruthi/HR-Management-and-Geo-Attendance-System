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

enum Designation {
  // TODO
  ADD_HERE
}

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
  ItsComplicated,
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
  String uID = '';
  String employeeID;
  String firstName;
  String? middleName;
  String? lastName;
  String? officeEmail;
  String? alternateEmail;
  String contactNumber = '';
  DateTime? dateOfBirth;
  DateTime? joiningDate;
  String residentialAddress = '';
  Gender? gender;
  int? retirementAge;

  Office? joiningUnit;
  SkillCategory? skillCategory;

  EmployeeFunction? employeeFunction;
  EmployeeSubFunction? employeeSubFunction;

  Grade? grade;
  String designation;

  MaritalStatus? maritalStatus;
  Religion? religion;

  Nationality? nationality;

  Entity? entity;
  BloodGroup? bloodGroup;

  EmployeeType? employeeType;
  Employee? reviewPerson;

  Role? role;

  Employee({
    required this.employeeID,
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.residentialAddress,
    required this.contactNumber,
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
    required this.designation,
    this.maritalStatus,
    this.religion,
    this.nationality,
    this.entity,
    this.bloodGroup,
    this.employeeType,
    this.reviewPerson,
    this.role,
  });

  Employee.fromSnapshot(DataSnapshot snapshot)
      : uID = (snapshot.value as Map)["UID"],
        employeeID = (snapshot.value as Map)["employeeID"],
        firstName = (snapshot.value as Map)["firstName"],
        middleName = (snapshot.value as Map)["middleName"],
        lastName = (snapshot.value as Map)["lastName"],
        officeEmail = (snapshot.value as Map)["officeEmail"],
        alternateEmail = (snapshot.value as Map)["alternateEmail"],
        dateOfBirth = (snapshot.value as Map)["dateOfBirth"],
        joiningDate = (snapshot.value as Map)["joiningDate"],
        gender = (snapshot.value as Map)["gender"],
        retirementAge = (snapshot.value as Map)["retirementAge"],
        joiningUnit = (snapshot.value as Map)["joiningUnit"],
        skillCategory = (snapshot.value as Map)["skillCategory"],
        employeeFunction = (snapshot.value as Map)["employeeFunction"],
        employeeSubFunction = (snapshot.value as Map)["employeeSubFunction"],
        grade = (snapshot.value as Map)["grade"],
        designation = (snapshot.value as Map)["designation"],
        maritalStatus = (snapshot.value as Map)["maritalStatus"],
        religion = (snapshot.value as Map)["religion"],
        nationality = (snapshot.value as Map)["nationality"],
        entity = (snapshot.value as Map)["entity"],
        bloodGroup = (snapshot.value as Map)["bloodGroup"],
        employeeType = (snapshot.value as Map)["employeeType"],
        reviewPerson = (snapshot.value as Map)["reviewPerson"],
        role = (snapshot.value as Map)["role"];

  toJson() {
    return {
      "employeeID": employeeID,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "officeEmail": officeEmail,
      "alternateEmail": alternateEmail,
      "dateOfBirth": dateOfBirth,
      "joiningDate": joiningDate,
      "gender": gender,
      "retirementAge": retirementAge,
      "joiningUnit": joiningUnit,
      "skillCategory": skillCategory,
      "employeeFunction": employeeFunction,
      "employeeSubFunction": employeeSubFunction,
      "grade": grade,
      "designation": designation,
      "maritalStatus": maritalStatus,
      "religion": religion,
      "nationality": nationality,
      "entity": entity,
      "bloodGroup": bloodGroup,
      "employeeType": employeeType,
      "reviewPerson": reviewPerson,
      "role": role,
    };
  }
}
