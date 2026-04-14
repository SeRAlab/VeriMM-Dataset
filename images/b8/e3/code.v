module top_module(
    input [3:0] input1,
    input [4:0] input2,
    input [5:0] input3,
    input [6:0] input4,
    input [7:0] input5,
    output reg [15:0] output1
);always @ (*) begin
    output1[3:0] = input1 * 2;
    output1[8:4] = input2 + input3;
    output1[15:9] = input4 | input5;
end

endmodule