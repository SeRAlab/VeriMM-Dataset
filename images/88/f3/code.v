module top_module(
    input [15:0] data_in,
    input [3:0] shift_amount,
    input shift_direction,
    output reg [15:0] data_out
);reg [15:0] stage1_out;
reg [15:0] stage2_out;
reg [15:0] stage3_out;

always @(data_in, shift_amount, shift_direction) begin
    stage1_out = (shift_direction == 0) ? (data_in << shift_amount) : (data_in >> shift_amount);
end

always @(stage1_out) begin
    stage2_out = stage1_out;
end

always @(stage2_out) begin
    stage3_out = stage2_out;
end

assign data_out = stage3_out;

endmodule