module top_module(
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);reg [7:0] stage1_out;
reg [7:0] stage2_out;

// Pipeline Stage 1
always @(*) begin
    stage1_out = in[15:8];
end

// Pipeline Stage 2
always @(*) begin
    stage2_out = in[7:0];
end

assign out_hi = stage1_out;
assign out_lo = stage2_out;

endmodule