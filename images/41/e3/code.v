module top_module(
    input [7:0] data_in1,
    input [7:0] data_in2,
    output out_and,
    output out_or,
    output out_xor
);wire [7:0] nor1_out;
wire [7:0] nor2_out;
wire [7:0] nor3_out;
wire [7:0] nor4_out;
wire [7:0] nor5_out;
wire [7:0] nor6_out;
wire [7:0] nor7_out;
wire [7:0] nor8_out;
wire [7:0] nor9_out;
wire [7:0] nor10_out;
wire [7:0] nor11_out;
wire [7:0] nor12_out;
wire [7:0] nor13_out;
wire [7:0] nor14_out;
wire [7:0] nor15_out;
wire [7:0] nor16_out;

// NOR gates for AND operation
assign nor1_out = ~(data_in1[0] | data_in2[0]);
assign nor2_out = ~(data_in1[1] | data_in2[1]);
assign nor3_out = ~(data_in1[2] | data_in2[2]);
assign nor4_out = ~(data_in1[3] | data_in2[3]);
assign nor5_out = ~(data_in1[4] | data_in2[4]);
assign nor6_out = ~(data_in1[5] | data_in2[5]);
assign nor7_out = ~(data_in1[6] | data_in2[6]);
assign nor8_out = ~(data_in1[7] | data_in2[7]);

// NOR gates for OR operation
assign nor9_out = ~(data_in1[0] & data_in2[0]);
assign nor10_out = ~(data_in1[1] & data_in2[1]);
assign nor11_out = ~(data_in1[2] & data_in2[2]);
assign nor12_out = ~(data_in1[3] & data_in2[3]);
assign nor13_out = ~(data_in1[4] & data_in2[4]);
assign nor14_out = ~(data_in1[5] & data_in2[5]);
assign nor15_out = ~(data_in1[6] & data_in2[6]);
assign nor16_out = ~(data_in1[7] & data_in2[7]);

// Output ports
assign out_and = ~(nor1_out | nor2_out | nor3_out | nor4_out | nor5_out | nor6_out | nor7_out | nor8_out);
assign out_or = ~(nor9_out & nor10_out & nor11_out & nor12_out & nor13_out & nor14_out & nor15_out & nor16_out);
assign out_xor = ~(out_and & out_or);

endmodule