module carry_save_adder(
    input [3:0] A,
    input [3:0] B,
    input [3:0] Cin,
    output [3:0] Sum,
    output Carry
);
    wire [4:0] temp_sum;
    
    assign temp_sum = A + B + Cin;
    assign Sum = temp_sum[3:0];
    assign Carry = temp_sum[4];
endmodule