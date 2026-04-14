module not_gate_16bit(
    input [15:0] a, 
    output [15:0] result);

    assign result = ~a;
endmodule