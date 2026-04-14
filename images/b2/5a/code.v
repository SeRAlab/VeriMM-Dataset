module top_module(
output reg[31:0]	q,
input[31:0]		d,
input		wrenable,
input		clk
);always @(negedge clk) begin
        q = 0;
    end
    
endmodule