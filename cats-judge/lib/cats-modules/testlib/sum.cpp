#include <fstream>

int main() {
    std::ifstream ifs("input.txt");
    std::ofstream ofs("output.txt");
    int a, b;
    ifs >> a >> b;
    ofs << a + b;
    return 0;
}
