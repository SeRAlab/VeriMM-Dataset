module top_module(
	 input CLK, RST,
    output reg [31:0] OUT
    );always @(posedge CLK) begin
	if(RST == 1) begin
		OUT <= 32'b0;
	end
	else begin
		OUT <= OUT + 1;
	end
end
endmodule