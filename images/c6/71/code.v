module mult_input(
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    input [31:0] in4,
    input [31:0] in5,
    output reg [31:0] out
);

    always @(*) begin
        out = in1 * in2 * in3 * in4 * in5;
    end

endmodule