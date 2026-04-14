module top_module(
	input wire [7:0] in,
	input wire pe_request,
	input clock,
	output reg [2:0] out,
	output reg pe_work

  );reg [2:0] out_temp;


  always @(posedge clock)
  begin
  #1
	if(!pe_request&&pe_work)
	begin
		casex (in)
		8'b1xxxxxxx : out <= 3'd7;
		8'b01xxxxxx : out <= 3'd6;
		8'b001xxxxx : out <= 3'd5;
		8'b0001xxxx : out <= 3'd4;
		8'b00001xxx : out <= 3'd3;
		8'b000001xx : out <= 3'd2;
		8'b0000001x : out <= 3'd1;
		8'b00000001 : out <= 3'd0;
		default     : out <= 3'd0;
		endcase
		pe_work<=1'b0;	
	end	
	else if(!pe_work)
	begin
		pe_work<=1'b1;
		out<=0;
	end
	else
	begin
		pe_work<=1'b1;
		out<=0;
	end
  end
  
  
  
  

   
endmodule