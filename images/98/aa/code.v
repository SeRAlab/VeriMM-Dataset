module top_module(Rs_addr, Rt_addr, Rd_addr, Clk, Rd_write_byte_en, Rd_in, Rs_out, Rt_out);input Clk;
input [4:0] Rs_addr, Rt_addr, Rd_addr;
input [7:0] Rd_in;
input Rd_write_byte_en;
output [7:0] Rs_out, Rt_out; 
reg [7:0] register[31:0];

always @(negedge Clk) begin
	if (Rd_addr != 0 && Rd_write_byte_en) begin
		register[Rd_addr][7:0] <= Rd_in[7:0];
	end
end

assign Rs_out = register[Rs_addr];
assign Rt_out = register[Rt_addr];

endmodule