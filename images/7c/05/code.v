module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    input Cin,
    output [3:0] R,
    output Cout
);wire [3:0] sum;
wire [3:0] twos_comp_B;
wire carry_in;

assign carry_in = Cin;

// Perform addition
assign sum = A + B + carry_in;

// Perform subtraction
assign twos_comp_B = ~B + 1;
assign sum = A + twos_comp_B + carry_in;

// Determine carry-out
assign Cout = (C==0) ? (sum[4]) : (~twos_comp_B[4]);

// Determine result
assign R = (C==0) ? (sum[3:0]) : (twos_comp_B[3:0]);

// Add 1 to result if Cin=1
assign R = (Cin==1) ? (R+1) : (R);

endmodule