module top_module(input clk, input rst, input [29:0] addr, output reg [31:0] inst);reg [29:0] addr_r;
always @(posedge clk)
begin
addr_r <= (rst) ? (30'b0) : (addr);
end
always @(*)
begin
case(addr_r)
30'h00000000: inst = 32'h3c1d1000;
30'h00000001: inst = 32'h37bd0100;
30'h00000002: inst = 32'h3c028000;
30'h00000003: inst = 32'h8c490010;
30'h00000004: inst = 32'h3c0a10d0;
30'h00000005: inst = 32'hac4a0014;
30'h00000006: inst = 32'h3c0b1040;
30'h00000007: inst = 32'hac4b0018;
30'h00000008: inst = 32'h3c0c00ff;
30'h00000009: inst = 32'h358c23ee;
30'h0000000a: inst = 32'hac4c001c;
default:      inst = 32'h00000000;
endcase
end
endmodule