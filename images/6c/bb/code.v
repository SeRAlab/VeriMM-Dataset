module top_module(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] Sum,
    output Cout
);wire [7:0] temp_sum;
    wire temp_carry;
    
    assign temp_sum = A + B + Cin;
    assign Sum = temp_sum[7:0];
    assign Cout = temp_sum[8];
    
endmodule