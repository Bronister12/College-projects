cmake_minimum_required(VERSION 3.10)
project(HealthApp VERSION 1.0 LANGUAGES CXX)

# 1) Require C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 2) Gather all .cpp files under src/
file(GLOB SRC_FILES
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
)

# 3) Define the executable
add_executable(healthapp
    ${SRC_FILES}
)

# 4) Tell the compiler where to find headers:
#    - include/ contains HealthData.h
#    - include/nlohmann/json.hpp for JSON
target_include_directories(healthapp
    PRIVATE
      ${CMAKE_SOURCE_DIR}/include
)
