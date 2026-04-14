module xor_const(
    input [31:0] in,
    output [31:0] out
);

parameter CONST = 32'hAAAAAAAA;

assign out = in ^ CONST;

endmodule