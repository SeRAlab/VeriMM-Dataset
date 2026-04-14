module top_module(ce, Q, sys_clk, TC, R, CEO);input ce;
output reg [3:0] Q = 0;
input sys_clk;
output wire TC;
input R;
output wire CEO;

assign TC = (Q == 15);
assign CEO = ce & TC;

always @(posedge sys_clk)
begin
        Q <= R ? 0 : ce ? Q + 1 : Q;
end

endmodule