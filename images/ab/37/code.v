module top_module(
    input [49:0] in,
    input clk,               // Added clk input
    output out_and,
    output out_or,
    output out_xor,
    output majority_out
);reg [49:0] stage1_out;
reg [49:0] stage2_out;
reg [49:0] stage3_out;

assign out_and = stage3_out[0];
assign out_or = stage3_out[1];
assign out_xor = stage3_out[2];
assign majority_out = stage3_out[3];

// Pipeline stage 1
always @(*) begin
    stage1_out = in;
end

// Pipeline stage 2
always @(posedge clk) begin
    stage2_out <= stage1_out;  // Changed to non-blocking assignment
end

// Pipeline stage 3
always @(posedge clk) begin
    stage3_out[0] <= &stage2_out;  // Changed to non-blocking assignment
    stage3_out[1] <= |stage2_out;  // Changed to non-blocking assignment
    stage3_out[2] <= ^stage2_out;  // Changed to non-blocking assignment
    stage3_out[3] <= (stage2_out[0] & stage2_out[1] & stage2_out[2]) |
                     (stage2_out[0] & stage2_out[1] & stage2_out[3]) |
                     (stage2_out[0] & stage2_out[2] & stage2_out[3]) |
                     (stage2_out[1] & stage2_out[2] & stage2_out[3]);  // Changed to non-blocking assignment
end

endmodule