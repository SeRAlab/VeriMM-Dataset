module top_module(
	
	input clk,
	input reset,
	
	
	input   [2:0]address,
	input        write,
	input  [31:0]writedata,
	input        read,
	output reg [31:0]readdata,

	output go,
	input full,
	output reg [11:0]memd,
	output memw,
	input busy,
	output tbm,
	input [31:0]rda
);wire [9:0]i2c_data;
	reg rdbff;

	assign memw = write & (address>=1) & (address<=5);
	assign i2c_data = {writedata[7:4], !writedata[4],
	              writedata[3:0], !writedata[0]};
  always @(*)
	case (address)
		2: memd <= {2'b00, i2c_data};
		3: memd <= {2'b10, i2c_data}; 
		4: memd <= {2'b01, i2c_data}; 
		5: memd <= {2'b11, i2c_data}; 
		default: memd <= writedata[11:0];
	endcase
	
	always @(*)
	case (address)
		1:      readdata <= rda;
		default readdata <= {1'b0, full, rdbff, busy || rda[31]};
	endcase

	
	always @(posedge clk or posedge reset)
	begin
		if (reset) rdbff <= 0;
		else if (write && (address == 0))
			rdbff = writedata[1];
	end
	
	assign tbm = rdbff;
	
	
	assign go = write & writedata[0] & (address == 0);
endmodule