module top_module(
    input [8:0] in1,
    input [8:0] in2,
    output [9:0] res
    );wire [5:0] temp1,temp2;

assign temp1[5:0] = in1[4:0] + in2[4:0];
assign temp2[5:0] = in1[8:4] + in2[8:4];

assign res[9:0] = {temp2[5:1],temp1[4:0]};

endmodule