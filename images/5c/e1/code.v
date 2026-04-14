module top_module(
	input 	clk,		    
  input clk7_en,
  input clk7n_en,
	input	_scs,			
	input	sdi,		  	
	output	sdo,	 		
	input	sck,	  		
	input	[7:0] in,		
	output reg	[7:0] out,		
	output	reg rx,		
	output	reg cmd,		
  output  vld     
);reg [2:0] bit_cnt;		
reg [7:0] sdi_reg;		
reg [7:0] sdo_reg;		

reg new_byte;			
reg rx_sync;			
reg first_byte;		


reg spi_valid=0, spi_valid_sync=0;
always @ (posedge clk) begin
  if (clk7_en) begin
    {spi_valid, spi_valid_sync} <= #1 {spi_valid_sync, ~_scs};
  end
end

assign vld = spi_valid;


always @(posedge sck)
		sdi_reg <= #1 {sdi_reg[6:0],sdi};

always @(posedge sck)
    if (bit_cnt==7)
      out <= #1 {sdi_reg[6:0],sdi};


always @(posedge sck or posedge _scs)
	if (_scs)
		bit_cnt <= #1 0;					
	else
		bit_cnt <= #1 bit_cnt + 3'd1;		




always @(posedge sck or posedge rx)
	if (rx)
		new_byte <= #1 0;		
	else if (bit_cnt == 3'd7)
		new_byte <= #1 1;		

always @(posedge clk)
  if (clk7n_en) begin
	  rx_sync <= #1 new_byte;	
  end

always @(posedge clk)
  if (clk7_en) begin
  	rx <= #1 rx_sync;			
  end




always @(posedge sck or posedge _scs)
	if (_scs)
		first_byte <= #1 1'b1;		
	else if (bit_cnt == 3'd7)
		first_byte <= #1 1'b0;		

always @(posedge sck)
	if (bit_cnt == 3'd7)
		cmd <= #1 first_byte;		
	

always @(negedge sck)	
	if (bit_cnt == 3'd0)
		sdo_reg <= #1 in;
	else
		sdo_reg <= #1 {sdo_reg[6:0],1'b0};


assign sdo = ~_scs & sdo_reg[7];	


endmodule