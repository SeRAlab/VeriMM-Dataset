module top_module(
    input clk,           // Added clk input signal
    input [3:0] D,
    input LD,
    input SH,
    output reg [3:0] Q
);reg [3:0] stage1, stage2, stage3, stage4;
    
    always @(posedge clk) begin
        if (LD) begin
            stage1 <= D;
            stage2 <= stage1;
            stage3 <= stage2;
            stage4 <= stage3;
        end
        else if (SH) begin
            stage1 <= stage2;
            stage2 <= stage3;
            stage3 <= stage4;
            stage4 <= 4'b0000;
        end
        else begin
            stage1 <= stage1;
            stage2 <= stage1;
            stage3 <= stage2;
            stage4 <= stage3;
        end
    end
    
    assign Q = stage1;
    
endmodule