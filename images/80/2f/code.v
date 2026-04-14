module top_module(
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);reg [7:0] stage1_out;
reg [7:0] stage2_out;

// Stage 1: Split the input into two bytes
always @(*) begin
    stage1_out = in[7:0];
end

// Stage 2: Split the remaining bits into the second byte
always @(*) begin
    stage2_out = in[15:8];
end

// Output the results
assign out_lo = stage1_out;
assign out_hi = stage2_out;

endmodule