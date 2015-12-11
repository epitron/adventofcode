#include <iostream>
#include <fstream>
#include <stdio.h>
#include <inttypes.h>

using namespace std;

// struct counts {
//   uint64_t a, b, c;
//   uint64_t total;
// };

int exists(char *filename) {
 std::ifstream infile(filename);
 return infile.good();
}

void inc_counts(uint64_t *counts, char c, uint64_t count) {
  if (c == '1')
    counts[0] += count;
  else if (c == '2')
    counts[1] += count;
  else if (c == '3')
    counts[2] += count;
  else
    cout << "Wtf: " << c;
}

#define BUFSIZE 4096

int seesay(int n) {
  char c, last = 0;
  int amount;
  uint64_t count = 0, counts[3] = {0,0,0};

  char infile[255], outfile[255], nextfile[255], buffer[BUFSIZE];

  sprintf(infile, "seesay-%d.txt", n);
  sprintf(outfile, "seesay-%d.txt", n+1);
  sprintf(nextfile, "seesay-%d.txt", n+2);

  if (exists(infile) && exists(outfile) && exists(nextfile)) {
    cout << "Skipping " << n << "...\n";
    return 0;
  }

  ofstream out(outfile, ios::binary);
  ifstream in(infile, ios::binary);
  // FILE *in;
  // in = fopen(infile, "r");
  // cout << infile << "\n";

  while (in) {
    // int amount = in.get(buffer,4096);
    in.read(buffer, BUFSIZE);
    amount = in.gcount();

    for (int i = 0; i < amount; i++) {
      c = buffer[i];

      if (c != last and last) {
        out << count << last;
        inc_counts(counts, last, count);
        count = 0;
      }

      last = c;
      count += 1;
    }
  }

  if (count > 0) {
    out << count << last;
    inc_counts(counts, last, count);
  }

  cout << n << " | " << counts[0] << ", " << counts[1] << ", " << counts[2] << "\n";
  return 0;
}

int main()
{
  // int n = 234;
  // ofstream file("blah.txt");
  // // ofstream file{"file.txt"};
  // file << "what" << 132;

  for (int i = 0; i < 300; i++) {
    seesay(i);
  }
}