module top_module(
    input [31:0] Din,
    output [31:0] Dout,
	 input CLK
);reg [31:0]tmp_out ;

always @(posedge CLK)
begin
	tmp_out <= Din;
end

assign Dout = tmp_out;

endmodule