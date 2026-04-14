module top_module(
    input [31:0] in,
    output [31:0] out
);reg [7:0] byte_0, byte_1, byte_2, byte_3;
reg [31:0] stage_1_out, stage_2_out, stage_3_out;

// Stage 1: Extract each byte from the input
assign byte_0 = in[7:0];
assign byte_1 = in[15:8];
assign byte_2 = in[23:16];
assign byte_3 = in[31:24];

// Stage 2: Reverse the order of the bytes
assign stage_1_out = {byte_3, byte_2, byte_1, byte_0};

// Stage 3: Combine the reversed bytes into a 32-bit output
assign stage_2_out = {stage_1_out[7:0], stage_1_out[15:8], stage_1_out[23:16], stage_1_out[31:24]};
assign stage_3_out = stage_2_out;

// Output the final result
assign out = stage_3_out;

endmodule