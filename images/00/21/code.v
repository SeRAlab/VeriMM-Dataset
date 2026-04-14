module four_bit_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output C_out
);
    wire [4:0] temp; // to hold the carry
    
    assign temp = A + B; // sum the inputs, including carry
    assign S = temp[3:0]; // the lower 4 bits are the sum
    assign C_out = temp[4]; // the carry out is the 5th bit
endmodule