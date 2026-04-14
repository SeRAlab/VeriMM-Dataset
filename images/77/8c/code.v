module top_module(
    input in1, // Binary input 1
    input in2, // Binary input 2
    output out_and, // AND output
    output out_or, // OR output
    output out_xor, // XOR output
    output [2:0] sum // Sum of the three outputs in binary form
);// AND gate
    assign out_and = in1 & in2;
    
    // OR gate
    assign out_or = in1 | in2;
    
    // XOR gate
    assign out_xor = in1 ^ in2;
    
    // Functional module to calculate sum
    assign sum = {out_and, out_or, out_xor};
    
endmodule