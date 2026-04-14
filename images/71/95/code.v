module top_module(
    input clk,
    input en,
    input rst,
    input [31:0] limit,
    input [31:0] count,
    output reg clk_0,
    output reg done
);reg [31:0] ndCount;
    reg [31:0] initCount;
    
    initial clk_0 = 1'b0;
    initial ndCount = 32'h00000000;
    initial initCount = 32'h00000000;
    
    always@(negedge clk or posedge rst) begin
        if(rst) begin
            clk_0 <= 1'b0;
            ndCount <= 32'h00000000;
            done <= 1'b0;
            initCount <= count;
        end
        else if(en) begin
            if(count < limit) begin
                ndCount <= count + 1;
                clk_0 <= (ndCount == limit) ? ~clk_0 : clk_0;
                done <= (ndCount == limit) ? 1'b1 : 1'b0;
            end
            else begin
                ndCount <= initCount;
                clk_0 <= 1'b0;
                done <= 1'b1;
            end
        end
        else begin
            ndCount <= initCount;
            clk_0 <= 1'b0;
            done <= 1'b0;
        end
    end

endmodule