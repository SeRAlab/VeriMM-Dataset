module top_module(
    input [15:0] in,
    output reg [3:0] out   // Changed to 'reg' to allow assignment in always block
);reg [3:0] stage1_out;
reg [15:0] stage2_out;
reg [3:0] stage3_out;

// Stage 1: Fetch input
always @(*) begin
    stage1_out = in[15:12];
end

// Stage 2: Split input into nibbles
always @(*) begin
    stage2_out[15:12] = in[15:12]; // Corrected input sections from in
    stage2_out[11:8]  = in[11:8]; 
    stage2_out[7:4]   = in[7:4]; 
    stage2_out[3:0]   = in[3:0];
end

// Stage 3: Detect consecutive 0's in each nibble
always @(*) begin
    stage3_out = 4'b0;
    if (stage2_out[15:12] == 4'b0000) stage3_out = stage3_out + 1;
    if (stage2_out[11:8] == 4'b0000) stage3_out = stage3_out + 1;
    if (stage2_out[7:4] == 4'b0000) stage3_out = stage3_out + 1;
    if (stage2_out[3:0] == 4'b0000) stage3_out = stage3_out + 1;
end

// Stage 4: Output total number of consecutive 0's found in input
always @(*) begin
    out = stage1_out + stage3_out;
end

endmodule