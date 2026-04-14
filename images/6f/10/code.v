module top_module(
    input [3:0] a,
    input [3:0] b,
    input clk,
    output reg equal
);reg [1:0] stage1_result [3:0];
reg stage2_result;

always @(posedge clk) begin
    stage1_result[0] <= {a[0] == b[0], a[1] == b[1]};
    stage1_result[1] <= {a[2] == b[2], a[3] == b[3]};
    stage1_result[2] <= {stage1_result[0][1], stage1_result[1][1]};
    stage1_result[3] <= {stage1_result[0][0], stage1_result[1][0]};
    
    stage2_result <= stage1_result[2] == 2'b11 && stage1_result[3] == 2'b11;
end

assign equal = stage2_result;

endmodule