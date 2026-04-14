module nand_gate_16bit(
    input [15:0] a, b, 
    output [15:0] result);

    assign result = ~(a & b);
endmodule