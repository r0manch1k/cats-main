#include <fstream>
#include <string>

int main() {
    std::ifstream ifs("input.txt");
    std::ofstream ofs("output.txt");
    std::string s;
    ifs >> s;
    ofs << s;
    return 0;
}
