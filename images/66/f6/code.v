module and_gate_32bit(
    input [31:0] a, b,
    output [31:0] y
);
    assign y = a & b;
endmodule