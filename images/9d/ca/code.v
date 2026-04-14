module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);wire and_gate_out;
    wire or_gate_out;
    
    // AND gate implementation
    assign and_gate_out = A & B & C;
    
    // OR gate implementation
    assign or_gate_out = A | B;
    
    // Final output implementation
    assign Y = and_gate_out | D | or_gate_out;
    
endmodule