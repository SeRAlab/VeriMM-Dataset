module top_module( BCLK, ENWR, DOWR, BYDIN, DIN, RADR, WADR, WMASKE, DOUT, SELI );input			BCLK;
input			DOWR,ENWR;
input	[31:0]	BYDIN,DIN;
input	 [7:0]	RADR;
input	 [5:0]	WADR;
input	 [1:0]	WMASKE;

output	[31:0]	DOUT;
output reg 		SELI;

reg	 	 [2:0] 	MX;

wire	 [3:0]	BE;
wire			eq_rw;



reg	 	 [7:0]	REGFILE_D [0:63];
reg	 	 [7:0]	REGFILE_C [0:63];
reg	 	 [7:0]	REGFILE_B [0:63];
reg	 	 [7:0]	REGFILE_A [0:63];
reg		[31:0]	RF;

assign	BE = {WMASKE[1],WMASKE[1],(WMASKE[1] | WMASKE[0]),1'b1};

assign	eq_rw = ENWR & (RADR[5:0] == WADR);

always @(posedge BCLK) if (RADR[7]) MX[2:0] <= BE[2:0] & {{3{eq_rw}}};

always @(posedge BCLK) if (RADR[7]) SELI <= RADR[6];

assign DOUT[31:16] = MX[2] ? BYDIN[31:16] : RF[31:16];
assign DOUT[15:8]  = MX[1] ? BYDIN[15:8]  : RF[15:8];
assign DOUT[7:0]   = MX[0] ? BYDIN[7:0]   : RF[7:0];
	


always @(posedge BCLK)
	if (RADR[7])
		begin
			RF[31:24] <= REGFILE_D[RADR[5:0]];
			RF[23:16] <= REGFILE_C[RADR[5:0]];
			RF[15:8]  <= REGFILE_B[RADR[5:0]];
			RF[7:0]   <= REGFILE_A[RADR[5:0]];
		end

always @(posedge BCLK)
	if (DOWR)
		begin
			if (BE[3]) REGFILE_D[WADR] <= DIN[31:24];
			if (BE[2]) REGFILE_C[WADR] <= DIN[23:16];
			if (BE[1]) REGFILE_B[WADR] <= DIN[15:8];
			if (BE[0]) REGFILE_A[WADR] <= DIN[7:0];
		end

endmodule