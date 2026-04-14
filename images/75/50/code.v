module top_module(
    clk,
	 clr,
	 def,
	 phase,
	 clk2,
    adr
);input clk;
input clr;
input [31:0]def;
input [7:0]phase;
output clk2;
output [7:0]adr;

reg [31:0]cnt = 0;

assign adr[7:0] = cnt[31:24]+phase[7:0];

assign clk2 = cnt[31];

always @(posedge clk or posedge clr) begin
    if (clr)
        cnt <= 0;
    else
        cnt <= cnt + def;
end

endmodule