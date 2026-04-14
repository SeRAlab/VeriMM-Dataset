module top_module(
    input [3:0] A,
    input [3:0] B,
    input op,
    input clk,
    output reg [3:0] result,
    output reg overflow
);always @(posedge clk) begin
        if (op == 0) begin // addition
            result <= A + B;
        end else begin // subtraction
            result <= A - B;
        end
        
        if (result > 15) begin // check for overflow
            overflow <= 1;
        end else begin
            overflow <= 0;
        end
    end
    
endmodule