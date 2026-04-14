module comparator_4bit(
    input wire [3:0] A,
    input wire [3:0] B,
    output wire A_greater,
    output wire A_equal,
    output wire A_less
    );

assign A_greater = (A > B) ? 1'b1 : 1'b0;
assign A_equal = (A == B) ? 1'b1 : 1'b0;
assign A_less = (A < B) ? 1'b1 : 1'b0;

endmodule