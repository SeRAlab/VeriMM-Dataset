module top_module(
    input [3:0] data_in,
    output reg [3:0] gray_out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

// Stage 1
always @(*) begin
    stage1_out[0] = data_in[0];
    stage1_out[1] = data_in[1] ^ data_in[0];
    stage1_out[2] = data_in[2] ^ data_in[1];
    stage1_out[3] = data_in[3] ^ data_in[2];
end

// Stage 2
always @(*) begin
    stage2_out[0] = stage1_out[0];
    stage2_out[1] = stage1_out[1] ^ stage1_out[0];
    stage2_out[2] = stage1_out[2] ^ stage1_out[1];
    stage2_out[3] = stage1_out[3] ^ stage1_out[2];
end

// Output
assign gray_out = stage2_out;

endmodule