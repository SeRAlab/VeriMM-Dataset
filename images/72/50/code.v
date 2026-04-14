module top_module(
    input [3:0] in,
    output [3:0] out
);wire [3:0] in_and_1;
wire [3:0] in_and_2;
wire [3:0] in_and_3;
wire [3:0] in_and_4;
wire [3:0] in_and_5;
wire [3:0] in_and_6;
wire [3:0] in_and_7;
wire [3:0] in_and_8;
wire [3:0] in_and_9;
wire [3:0] in_and_10;
wire [3:0] in_and_11;
wire [3:0] in_and_12;
wire [3:0] in_and_13;
wire [3:0] in_and_14;
wire [3:0] in_and_15;

assign in_and_1 = {4{1'b1}} & {in};
assign in_and_2 = {2{1'b1}} & {in[3:2]};
assign in_and_3 = {2{1'b1}} & {in[2:1]};
assign in_and_4 = {2{1'b1}} & {in[1:0]};
assign in_and_5 = {4{1'b0}} & {in};
assign in_and_6 = {2{1'b0}} & {in[3:2]};
assign in_and_7 = {2{1'b0}} & {in[2:1]};
assign in_and_8 = {2{1'b0}} & {in[1:0]};
assign in_and_9 = {3{1'b1}} & {in[3:1]};
assign in_and_10 = {3{1'b1}} & {in[2:0]};
assign in_and_11 = {3{1'b0}} & {in[3:1]};
assign in_and_12 = {3{1'b0}} & {in[2:0]};
assign in_and_13 = {2{1'b1}} & {in[3], in[1]};
assign in_and_14 = {2{1'b0}} & {in[3], in[1]};
assign in_and_15 = {2{1'b1}} & {in[2], in[0]};

assign out = in_and_1 + in_and_2 + in_and_3 + in_and_4 + in_and_5 + in_and_6 + in_and_7 + in_and_8 + in_and_9 + in_and_10 + in_and_11 + in_and_12 + in_and_13 + in_and_14 + in_and_15;

endmodule