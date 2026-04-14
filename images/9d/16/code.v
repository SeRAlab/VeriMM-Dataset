module top_module(
    input clk,
    input rst,
    input en,
    input op,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] result,
    output reg overflow
);always @(posedge clk) begin
        if(rst == 1) begin
            result <= 0;
            overflow <= 0;
        end
        else if(en == 1) begin
            if(op == 0) begin
                result <= a + b;
            end
            else begin // op == 1
                result <= a - b;
            end
            
            if(result > 255) begin
                overflow <= 1;
                result <= result[7:0];
            end
            else begin
                overflow <= 0;
            end
        end
        else begin // en == 0
            result <= 0;
            overflow <= 0;
        end
    end

endmodule