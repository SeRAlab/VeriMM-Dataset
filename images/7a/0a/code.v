module top_module(
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);reg [7:0] stage1_out_hi;
reg [7:0] stage1_out_lo;
reg [7:0] stage2_out_hi;
reg [7:0] stage2_out_lo;

// Pipeline stage 1
always @(*) begin
    stage1_out_hi = in[15:8];
    stage1_out_lo = in[7:0];
end

// Pipeline stage 2
always @(*) begin
    stage2_out_hi = stage1_out_hi;
    stage2_out_lo = stage1_out_lo;
end

assign out_hi = stage2_out_hi;
assign out_lo = stage2_out_lo;

endmodule