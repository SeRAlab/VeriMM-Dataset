module top_module(
    input clk,        // Added clk input
    input a, 
    input b,
    output reg out_assign,
    output reg out_alwaysblock
);reg [1:0] stage1_out;
reg [1:0] stage2_out;
reg [1:0] stage3_out;

always @ (posedge clk) begin
    stage1_out <= {a, b};
end

always @ (posedge clk) begin
    stage2_out <= {stage1_out[0] & stage1_out[1], stage1_out[0] & stage1_out[1]};
end

always @ (posedge clk) begin
    stage3_out <= {stage2_out[0] & stage2_out[1], stage2_out[0] & stage2_out[1]};
    out_assign <= stage3_out[0] & stage3_out[1];
    out_alwaysblock <= stage3_out[0] & stage3_out[1];
end

endmodule