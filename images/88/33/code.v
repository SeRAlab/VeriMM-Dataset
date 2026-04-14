module top_module(
    input [31:0] in_vec,
    output [31:0] out_vec
);reg [31:0] stage1_out;
reg [31:0] stage2_out;
reg [31:0] stage3_out;

// Stage 1
always @(*) begin
    stage1_out[7:0] = in_vec[15:8];
    stage1_out[15:8] = in_vec[7:0];
    stage1_out[23:16] = in_vec[31:24];
    stage1_out[31:24] = in_vec[23:16];
end

// Stage 2
always @(*) begin
    stage2_out[7:0] = stage1_out[23:16];
    stage2_out[15:8] = stage1_out[31:24];
    stage2_out[23:16] = stage1_out[7:0];
    stage2_out[31:24] = stage1_out[15:8];
end

// Stage 3
always @(*) begin
    stage3_out[7:0] = stage2_out[15:8];
    stage3_out[15:8] = stage2_out[7:0];
    stage3_out[23:16] = stage2_out[31:24];
    stage3_out[31:24] = stage2_out[23:16];
end

assign out_vec = stage3_out;

endmodule