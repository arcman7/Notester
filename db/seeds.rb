# require "faker"


# arcman77     = User.create(username:"arcman77", email: "andrewryancarpenter77@gmail.com")
# creatorkarma = User.create(username:"creatorkarma", email: "jms@creatorkarma.com");
# vrturo       = User.create(username: "vrturo", email: "vrturo@gmail.com");

# codeLang = Category.create(name: "Programming Languages")
# assembler = Category.create(name: "Assembler")

# #rCodeLang = Resource.create(title: "Assembler")
# #rAssembler= Resource.create(title: "Fortran")

# codeLang.sub_categories << assembler

# fortran = Category.create(name: "Fortran")
# lisp    = Category.create(name: "Lisp")
# apl     = Category.create(name: "APL")
# assembler.sub_categories << fortran
# assembler.sub_categories << lisp
# assembler.sub_categories << apl

# basic = Category.create(name: "Basic")
# algo60= Category.create(name: "Algo60")
# cobal = Category.create(name: "Cobal")
# bcpl  = Category.create(name: "BCPL")
# fortran77=Category.create(name: "Fortran77")

# fortran.sub_categories << bcpl
# fortran.sub_categories << basic
# fortran.sub_categories << algo60
# fortran.sub_categories << cobal
# fortran.sub_categories << lisp
# fortran.sub_categories << fortran77

# algo_W = Category.create(name: "Algo-W")
# simula = Category.create(name: "Simula")
# algo68 = Category.create(name: "Algo68")
# pl_1   = Category.create(name: "PL-1")

# algo60.sub_categories << algo_W
# algo60.sub_categories << simula
# algo60.sub_categories << algo68
# algo60.sub_categories << pl_1

# object_cobal = Category.create(name: "Object Cobal")

# cobal.sub_categories << object_cobal
# cobal.sub_categories << pl_1

# smalltalk_80 = Category.create(name: "Smaltalk-80")
# loops       = Category.create(name: "Loops")
# prolog      = Category.create(name: "Prolog")
# ml          = Category.create(name: "ML")
# logo        = Category.create(name: "Logo")
# java        = Category.create(name: "Java")

# lisp.sub_categories << java
# lisp.sub_categories << logo
# lisp.sub_categories << smalltalk_80
# lisp.sub_categories << loops
# lisp.sub_categories << prolog
# lisp.sub_categories << ml



# pascal = Category.create(name: "Pascal")

# algo_W.sub_categories << pascal

# modula_2 = Category.create(name: "Modula-2")
# eiffel   = Category.create(name: "Eiffel")
# cplusplus= Category.create(name: "C++")

# simula.sub_categories << modula_2
# simula.sub_categories << smalltalk_80
# simula.sub_categories << eiffel
# simula.sub_categories << cplusplus

# c   = Category.create(name: "C")
# ada = Category.create(name: "Ada")

# algo68.sub_categories << c
# algo68.sub_categories << ada

# bcpl.sub_categories << c

# miranda = Category.create(name: "Miranda")
# haskell = Category.create(name: "Haskell")

# ml.sub_categories << miranda
# miranda.sub_categories << haskell

# mesa  = Category.create(name: "Mesa")
# sather= Category.create(name: "Sather")

# pascal.sub_categories << modula_2
# pascal.sub_categories << mesa
# pascal.sub_categories << ada
# pascal.sub_categories << sather

# mesa.sub_categories << modula_2
# mesa.sub_categories << ada

# objectiveC = Category.create(name: "Objective C")
# csharp = Category.create(name: "C#")

# c.sub_categories << cplusplus
# c.sub_categories << objectiveC
# c.sub_categories << csharp

# fortran90 = Category.create(name: "Fortran 90")
# fortran77.sub_categories << fortran90

# clos = Category.create(name: "CLOS")

# loops.sub_categories << clos

# modula_3 = Category.create(name: "Modula-3")
# oberon_2 = Category.create(name: "Oberon-2")

# modula_2.sub_categories << modula_3
# modula_2.sub_categories << oberon_2
# modula_2.sub_categories << eiffel
# modula_2.sub_categories << ada

# component_pascal = Category.create(name: "Component Pascal")
# ada9X = Category.create(name: "Ada 9X")

# ada.sub_categories << component_pascal
# ada.sub_categories << ada9X

# smalltalk_80.sub_categories << java
# smalltalk_80.sub_categories << cplusplus
# smalltalk_80.sub_categories << sather
# smalltalk_80.sub_categories << objectiveC
# smalltalk_80.sub_categories << clos

# objectiveC.sub_categories << sather
# objectiveC.sub_categories << java

# modula_3.sub_categories << java
# modula_3.sub_categories << sather

# oberon_2.sub_categories << component_pascal
# oberon_2.sub_categories << java

# java.sub_categories << component_pascal
# java.sub_categories << csharp

# eiffel.sub_categories << csharp

# sather.sub_categories << csharp

# programming_languages = Tag.create(name: "programming languages")
# coding = Tag.create(name: "coding")
# computer_language = Tag.create(name: "Computer Language")


# Category.all.each do |category|
#   tag = Tag.create(name: category.name)
#   category.tags << tag
#   category.tags << programming_languages
#   category.tags << coding
#   category.tags << computer_language
# end

10.times do Category.find(1).resources.create(title: Faker::Commerce.department, description: Faker::Lorem.paragraphs(3), user_id: 3) end

