module top_module(
    input [67:0] Din,
    output [67:0] Dout,
	 input CLK
);reg [67:0]tmp_out [1:0];

always @(posedge CLK)
begin
	tmp_out[0] <= Din;
	tmp_out[1] <= tmp_out[0];
end

assign Dout = tmp_out[1];

endmodule