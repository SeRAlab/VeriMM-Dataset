module top_module(
    input [19:0] Data_A_i,
    input [19:0] Data_B_i,
    output [2:0] O,
    output CO,
    output [3:0] S,
    output [3:0] DI
);// Removed the redeclaration of output ports
  wire [19:0] Sum; // Intermediate sum variable
  
  assign Sum = Data_A_i + Data_B_i;
  assign O = Sum[2:0]; // First 3 bits of the sum
  assign CO = Sum[20]; // Carry out (20th bit of the sum)
  assign S = Sum[3:0]; // Lower 4 bits of the sum
  assign DI = {CO, S[3:1]}; // Concatenate carry and S[3:1]

endmodule