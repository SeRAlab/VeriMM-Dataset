module top_module(a_in , s_out);input a_in;
  output [7:0] s_out;

  reg [7:0] temp;
  assign s_out = temp;
  always @(a_in) begin
  	if(a_in == 1) begin
  	    temp = 8'b01000000;
  	end
  	else begin
  		temp = 8'b00000000;
  	end
  end
endmodule