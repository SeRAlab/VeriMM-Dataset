module z80memr (
	input clk,
	output [15:0] a,
	output [7:0] d,
	output mreq,
	output rd
	);
	reg rmreq = 1;
	reg rrd = 1;
	assign mreq = rmreq;
	assign rd = rrd;
	reg [1:0] estado = 2;
	assign d = 8'bzzzzzzzz;
	reg [15:0] ra = 16'h7FFF;
	assign a = ra;
	always @(posedge clk) begin
		if (estado==2) begin
			estado <= 0;
			ra <= ~ra;
		end
		else
			estado <= estado + 1;
	end
	always @(*) begin
		if (estado==0 && clk)
			{rmreq,rrd} = 2'b11;
		else if (estado==0 && !clk)
			{rmreq,rrd} = 2'b00;
		else if (estado==1)
			{rmreq,rrd} = 2'b00;
		else if (estado==2 && clk)
			{rmreq,rrd} = 2'b00;
		else
			{rmreq,rrd} = 2'b11;
	end
endmodule