module top_module(
    input [3:0] ABCD,
    input clk,              // Added clk as an input
    output reg [15:0] out
);reg [15:0] stage1_out;
reg [15:0] stage2_out;

always @ (posedge clk) begin
    stage1_out <= {~ABCD[0], ~ABCD[1], ~ABCD[2], ~ABCD[3]};
end

always @ (posedge clk) begin
    stage2_out <= {stage1_out[0], stage1_out[1], stage1_out[2], stage1_out[3], 
                   stage1_out[4], stage1_out[5], stage1_out[6], stage1_out[7], 
                   stage1_out[8], stage1_out[9], stage1_out[10], stage1_out[11], 
                   stage1_out[12], stage1_out[13], stage1_out[14], stage1_out[15]};
end

assign out[0] = ~stage2_out[0];
assign out[1] = ~stage2_out[1];
assign out[2] = ~stage2_out[2];
assign out[3] = ~stage2_out[3];
assign out[4] = ~stage2_out[4];
assign out[5] = ~stage2_out[5];
assign out[6] = ~stage2_out[6];
assign out[7] = ~stage2_out[7];
assign out[8] = ~stage2_out[8];
assign out[9] = ~stage2_out[9];
assign out[10] = ~stage2_out[10];
assign out[11] = ~stage2_out[11];
assign out[12] = ~stage2_out[12];
assign out[13] = ~stage2_out[13];
assign out[14] = ~stage2_out[14];
assign out[15] = ~stage2_out[15];

endmodule