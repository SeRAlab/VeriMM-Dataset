module top_module(
    input [1:0] input1,
    input [2:0] input2,
    input [3:0] input3,
    input [4:0] input4,
    input [5:0] input5,
    output [6:0] output1
);assign output1 = {input1[1:0], input2[2], input3[3:1], input4[4:1], input5[5:1]};

endmodule