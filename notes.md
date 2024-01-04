# Notes on How to Configure #

## clang ##

clangd is the LSP server for C, C++, C#, Obj-C source files
clangd LSP server uses clang-format program to format source files
default formatting options can be overridden by .clang-format file
clang-format knows few styles of formatting
* llvm (default)
* gnu
* google
* chromium
* microsoft
* mozilla
* webkit

.clang-format file can be generated in one of many ways like so,
```
clang-format -style=Microsoft -dump-config > .clang-format
clang-format -style="{ BasedOnStyle: Google, IndentWidth: 8 }" -dump-config > .clang-format
```
