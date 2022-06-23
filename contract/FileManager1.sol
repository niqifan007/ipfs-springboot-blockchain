pragma solidity >=0.8.0;

contract FileManager {
  // 保存文件结构体
  struct File {
    string fileName;
    string fileType;
    string cid;
  }

  // 每个用户的地址与他们所存储的文件阵列的映射关系
  mapping(address => File[]) files;

  function addFile(string[] memory _fileInfo, string  memory _cid) public {
    files[msg.sender].push(File(_fileInfo[0], _fileInfo[1], _cid));
  }

  function getFiles(address _account) public  view  returns (File[] memory) {
    return files[_account];
  }
}