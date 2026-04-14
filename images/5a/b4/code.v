module top_module(
    input clk,
    output reg [1:0] cnt
);always @(posedge clk)
    begin
        cnt <= cnt + 1; 
    end

endmodule