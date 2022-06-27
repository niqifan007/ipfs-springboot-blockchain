package com.example.ipfsdemon;

import org.springframework.web.multipart.MultipartFile;

public interface FileServiceImpl {

    void download(String hash, String destFile);

    String saveFile(String filePath);
    String saveFile(MultipartFile file);

    byte[] loadFile(String hash);
}
