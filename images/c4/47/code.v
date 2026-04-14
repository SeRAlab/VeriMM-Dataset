module logic_function (
    input clk,
    input rst,
    input [3:0] din,
    output dout
);

// XOR the bits of the input together to count the number of 1's
wire [1:0] xor1 = din[0] ^ din[1];
wire [1:0] xor2 = din[2] ^ din[3];
wire [1:0] xor3 = xor1 ^ xor2;
wire [0:0] xor4 = xor3[0] ^ xor3[1];

// Invert the output to get the desired output
assign dout = ~xor4;

endmodule