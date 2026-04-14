module top_module(
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);reg [15:0] stage1_out;
reg [7:0] stage2_out_hi;
reg [7:0] stage2_out_lo;

// Stage 1: Barrel shifter
always @(*) begin
    stage1_out = in >> 8;
end

// Stage 2: Multiplexer
always @(*) begin
    stage2_out_hi = stage1_out[15:8];
    stage2_out_lo = stage1_out[7:0];
end

// Output
assign out_hi = stage2_out_hi;
assign out_lo = stage2_out_lo;

endmodule