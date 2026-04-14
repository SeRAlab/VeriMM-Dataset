module top_module(
    input [3:0] A,
    input [3:0] B,
    output [1:0] Y,
    output V,
    output equal,
    output greater,
    output result
);// 4-to-2 Priority Encoder
    wire [3:0] priority_input;
    assign priority_input = (A > B) ? A : B;
    assign Y = (priority_input == 4'b0000) ? 2'b00 :
               (priority_input == 4'b0001) ? 2'b01 :
               (priority_input == 4'b0010) ? 2'b10 :
                                           2'b11;
    assign V = (priority_input == 4'b0000);

    // 4-bit Magnitude Comparator
    assign equal = (A == B);
    assign greater = (A > B);

    // Bitwise AND and OR operations
    wire [1:0] Y_and_greater;
    assign Y_and_greater = Y & greater;
    assign result = Y_and_greater[1] | Y_and_greater[0] | V;

endmodule