module top_module(marks, grade);input [3:0] marks;

  output [1:0] grade;
  reg [1:0] grade;

  always @(marks)
    if (marks < 5)
      grade = 0;
    else if (marks < 7)
      grade = 1;
    else
      grade = 2;
endmodule