module VGA_CRT(
    input CE,
	 input WR,
	 input [7:0]din,
	 input addr,
	 output [7:0]dout,
	 input CLK,
	 output reg oncursor,
	 output wire [11:0]cursorpos,
	 output wire [15:0]scraddr
    );
	reg [7:0]crtc[3:0];
	reg [2:0]index = 0;
	assign dout = crtc[index[1:0]];
	assign cursorpos = {crtc[2][3:0], crtc[3]};
	assign scraddr = {crtc[0], crtc[1]};
	always @(posedge CLK) if(CE && WR) begin
		if(addr) begin
			if(index[2]) crtc[index[1:0]] <= din;
			else if(index[1:0] == 2'b10) oncursor <= din[5];
		end else index <= din[2:0];
	end
endmodule