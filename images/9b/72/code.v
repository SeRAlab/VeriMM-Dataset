module decoder_2to4(
    input [1:0] in,
    output [3:0] out);
    
    assign out = 1 << in; // Shift 1 left by the value of in to generate the decoded output
endmodule