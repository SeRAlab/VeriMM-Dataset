module twos_complement(
    input [3:0] in,
    output [3:0] out
);

    wire [3:0] neg_in;
    
    assign neg_in = ~in + 1'b1;
    assign out = neg_in;
    
endmodule