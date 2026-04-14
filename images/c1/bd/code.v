module SOUND_LATCH(
  output reg [7:0] dout,  
  input enable,
  input clk,
  input rd_n );
wire sample = clk & ~rd_n;
reg [7:0]data;
initial begin
	dout=0;
	data=0;
	#100e6 data=8'h12; 
end
always @(posedge sample) begin
  if( !enable )
		dout=0;
  else begin 
    if( !rd_n ) begin
			dout=data;
		end
  end
end
endmodule