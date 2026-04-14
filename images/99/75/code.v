module top_module(clk ,select, sd, d, q);input clk;
input select;
input sd;
input d;
output reg q;
wire f;


assign f = (select)? sd : d;

always @(negedge clk) begin
    q <= f;
end
    
endmodule