module top_module(
    input [3:0] in_0,
    input [3:0] in_1,
    output reg [7:0] out
);reg [3:0] stage_1_out;
reg [3:0] stage_2_out;
reg [3:0] stage_3_out;
reg [3:0] stage_4_out;

always @(*) begin
    stage_1_out = in_0 * in_1[0];
end

always @(*) begin
    stage_2_out = {stage_1_out[2:0], 1'b0} + (in_0 * in_1[1]);
end

always @(*) begin
    stage_3_out = {stage_2_out[3:0], 2'b00} + (in_0 * in_1[2]);
end

always @(*) begin
    stage_4_out = {stage_3_out[3:0], 3'b000} + (in_0 * in_1[3]);
end

always @(*) begin
    out = {stage_4_out, 1'b0};
    out[7] = ^out[6:0];
end

endmodule