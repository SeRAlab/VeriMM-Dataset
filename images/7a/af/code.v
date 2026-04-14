module top_module(input [3:0] I, input [1:0] S, output O);wire w1, w2, w3;

// Implementing a simple 2-to-1 MUX for the given inputs instead of MUXF7
assign w1 = S[0] ? I[1] : I[0]; // First stage MUX for I[0] and I[1]
assign w2 = S[0] ? I[3] : I[2]; // First stage MUX for I[2] and I[3]
assign w3 = S[1] ? w2 : w1;     // Second stage MUX for w1 and w2

assign O = w3; // Final output

endmodule