module eight_bit_adder (
    input [7:0] A,
    input [7:0] B,
    output [7:0] SUM,
    output COUT
);
    wire [8:0] temp_sum;
    
    assign temp_sum = A + B; // add the two 8-bit numbers
    assign SUM = temp_sum[7:0]; // take the lower 8 bits as sum
    assign COUT = temp_sum[8]; // the 9th bit is carry out

endmodule