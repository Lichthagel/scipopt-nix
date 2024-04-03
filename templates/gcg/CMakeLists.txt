cmake_minimum_required(VERSION 3.5)

project(my_project LANGUAGES C)

find_package(SCIP REQUIRED)
find_package(GCG REQUIRED)

add_executable(my_project main.c)

target_link_libraries(my_project PRIVATE ${SCIP_LIBRARIES} ${GCG_LIBRARIES})

target_include_directories(my_project PRIVATE ${SCIP_INCLUDE_DIRS} ${GCG_INCLUDE_DIRS})