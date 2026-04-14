module and_gate_4bit(
    input [3:0] a, b,
    output [3:0] result);
    
    assign result = a & b;
endmodule