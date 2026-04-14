module resets(
	reset_in,
	clk,
	M1,
	T2,
	fpga_reset,
	nhold_clk_wait,
	clrpc,
	nreset
);
input wire	reset_in;
input wire	clk;
input wire	M1;
input wire	T2;
input wire	fpga_reset;
input wire	nhold_clk_wait;
output wire	clrpc;
output wire	nreset;
reg	clrpc_int;
wire	nclk;
reg	x1;
wire	x2;
wire	x3;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_1;
reg	SYNTHESIZED_WIRE_9;
reg	DFFE_intr_ff3;
reg	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_3;
reg	SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_6;
assign	nreset = SYNTHESIZED_WIRE_6;
always@(posedge nclk or negedge SYNTHESIZED_WIRE_8)
begin
if (!SYNTHESIZED_WIRE_8)
	begin
	x1 <= 1;
	end
else
	begin
	x1 <= ~x1 & reset_in | x1 & ~SYNTHESIZED_WIRE_1;
	end
end
assign	clrpc = clrpc_int | SYNTHESIZED_WIRE_9 | DFFE_intr_ff3 | SYNTHESIZED_WIRE_10;
assign	SYNTHESIZED_WIRE_1 =  ~reset_in;
assign	x2 = x1 & SYNTHESIZED_WIRE_11;
assign	SYNTHESIZED_WIRE_11 = M1 & T2;
assign	x3 = x1 & SYNTHESIZED_WIRE_3;
assign	SYNTHESIZED_WIRE_6 =  ~SYNTHESIZED_WIRE_12;
assign	SYNTHESIZED_WIRE_3 =  ~SYNTHESIZED_WIRE_11;
assign	nclk =  ~clk;
assign	SYNTHESIZED_WIRE_8 =  ~fpga_reset;
always@(posedge nclk)
begin
if (nhold_clk_wait)
	begin
	DFFE_intr_ff3 <= SYNTHESIZED_WIRE_9;
	end
end
always@(posedge nclk)
begin
if (nhold_clk_wait)
	begin
	SYNTHESIZED_WIRE_10 <= SYNTHESIZED_WIRE_12;
	end
end
always@(posedge nclk)
begin
if (nhold_clk_wait)
	begin
	SYNTHESIZED_WIRE_9 <= SYNTHESIZED_WIRE_10;
	end
end
always@(posedge clk or negedge SYNTHESIZED_WIRE_8)
begin
if (!SYNTHESIZED_WIRE_8)
	begin
	SYNTHESIZED_WIRE_12 <= 1;
	end
else
	begin
	SYNTHESIZED_WIRE_12 <= x3;
	end
end
always@(posedge nclk or negedge SYNTHESIZED_WIRE_6)
begin
if (!SYNTHESIZED_WIRE_6)
	begin
	clrpc_int <= 0;
	end
else
	begin
	clrpc_int <= ~clrpc_int & x2 | clrpc_int & ~SYNTHESIZED_WIRE_11;
	end
end
endmodule