module multiplier_32bit (
    input [31:0] a,
    input [31:0] b,
    output [63:0] product
);
    assign product = a * b; // Using Verilog's multiply operator for combinational logic
endmodule