module top_module(
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);reg [3:0] stage1_out0, stage1_out1, stage1_out2, stage1_out3, stage1_out4, stage1_out5;
reg [3:0] stage2_out0, stage2_out1, stage2_out2, stage2_out3;
reg [3:0] stage3_out0, stage3_out1;
reg [3:0] stage4_out;

// Stage 1
assign stage1_out0 = (sel[0] == 0) ? data0 : data1;
assign stage1_out1 = (sel[0] == 0) ? data2 : data3;
assign stage1_out2 = (sel[0] == 0) ? data4 : data5;
assign stage1_out3 = (sel[0] == 1) ? data0 : data1;
assign stage1_out4 = (sel[0] == 1) ? data2 : data3;
assign stage1_out5 = (sel[0] == 1) ? data4 : data5;

// Stage 2
assign stage2_out0 = (sel[1] == 0) ? stage1_out0 : stage1_out1;
assign stage2_out1 = (sel[1] == 0) ? stage1_out2 : stage1_out3;
assign stage2_out2 = (sel[1] == 1) ? stage1_out0 : stage1_out1;
assign stage2_out3 = (sel[1] == 1) ? stage1_out2 : stage1_out3;

// Stage 3
assign stage3_out0 = (sel[2] == 0) ? stage2_out0 : stage2_out1;
assign stage3_out1 = (sel[2] == 1) ? stage2_out2 : stage2_out3;

// Stage 4
assign stage4_out = (sel[2] == 0) ? stage3_out0 : stage3_out1;

always @(*) begin
    out = stage4_out;
end

endmodule