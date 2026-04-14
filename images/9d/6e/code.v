module top_module(
    input clk,
    input d,
    output reg q );reg [1:0] stage1_d;
    reg [1:0] stage2_d;
    reg [1:0] stage3_d;
    
    always @(posedge clk) begin
        stage1_d <= {stage2_d[0], d};
        stage2_d <= {stage3_d[0], stage1_d[1]};
        stage3_d <= {1'b0, stage2_d[1]};
        q <= stage3_d[1];
    end
    
endmodule