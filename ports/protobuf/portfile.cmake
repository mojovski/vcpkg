#tool
include(vcpkg_common_functions)
vcpkg_download_distfile(ARCHIVE_FILE
    #URLS "https://github.com/google/protobuf/releases/download/v3.0.2/protobuf-cpp-3.0.2.tar.gz"
    URLS "https://github.com/google/protobuf/releases/download/v3.1.0/protobuf-cpp-3.1.0.tar.gz"
	FILENAME "protobuf-cpp-3.1.0.tar.gz"
    SHA512 9f85a98e55cbc9f245a3079d5a597f778454bc945f0942cb10fbdfbde5fe12b17d6dda93d6a8d5281459ad30a3840be7e0712feb33a824226884e7e4da54a061
)
vcpkg_download_distfile(TOOL_ARCHIVE_FILE
    #URLS "https://github.com/google/protobuf/releases/download/v3.0.2/protoc-3.0.2-win32.zip"
	URLS "https://github.com/google/protobuf/releases/download/v3.1.0/protoc-3.1.0-win32.zip"
    FILENAME "protoc-3.1.0-win32.zip"
    SHA512 f46ebe162b9dacefd622a6b9de367f10e51347439a4f9d069dcd57e45e4ae4572ff765043537820f8be32cdc75e346e0769f8a0012777d2c33f870507b6618b1
)
vcpkg_extract_source_archive(${ARCHIVE_FILE})
vcpkg_extract_source_archive(${TOOL_ARCHIVE_FILE} ${CURRENT_BUILDTREES_DIR}/src/protobuf-3.0.2-win32)

vcpkg_configure_cmake(
    SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/protobuf-3.0.2/cmake
    OPTIONS
        -Dprotobuf_BUILD_SHARED_LIBS=OFF
        -Dprotobuf_MSVC_STATIC_RUNTIME=OFF
        -Dprotobuf_WITH_ZLIB=ON
        -Dprotobuf_BUILD_TESTS=OFF
        -DCMAKE_INSTALL_CMAKEDIR=share/protobuf
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(READ ${CURRENT_PACKAGES_DIR}/share/protobuf/protobuf-targets-release.cmake RELEASE_MODULE)
string(REPLACE "\${_IMPORT_PREFIX}/bin/protoc.exe" "\${_IMPORT_PREFIX}/tools/protoc.exe" RELEASE_MODULE "${RELEASE_MODULE}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/protobuf/protobuf-targets-release.cmake "${RELEASE_MODULE}")

file(READ ${CURRENT_PACKAGES_DIR}/debug/share/protobuf/protobuf-targets-debug.cmake DEBUG_MODULE)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" DEBUG_MODULE "${DEBUG_MODULE}")
string(REPLACE "\${_IMPORT_PREFIX}/debug/bin/protoc.exe" "\${_IMPORT_PREFIX}/tools/protoc.exe" DEBUG_MODULE "${DEBUG_MODULE}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/protobuf/protobuf-targets-debug.cmake "${DEBUG_MODULE}")

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(REMOVE ${CURRENT_PACKAGES_DIR}/bin/protoc.exe)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/protoc.exe)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)

file(INSTALL ${CURRENT_BUILDTREES_DIR}/src/protobuf-3.0.2/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/protobuf RENAME copyright)
file(INSTALL ${CURRENT_BUILDTREES_DIR}/src/protobuf-3.0.2-win32/bin/protoc.exe DESTINATION ${CURRENT_PACKAGES_DIR}/tools)
vcpkg_copy_pdbs()
