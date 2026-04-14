module top_module(
   input 	     clk,
   input [31:0]      afl,
   output reg [15:0] fx_int
   );reg [14:0] 	     int_out;

  always @* begin
    if(afl[30:23] == 8'h7f) int_out = 16'h1;		
    else begin
      casex(afl[30:23])
	8'b0xxx_xxxx: int_out = 15'h0;			
	8'b1000_0000: int_out = {14'h1, afl[22]};	
	8'b1000_0001: int_out = {13'h1, afl[22:21]};	
	8'b1000_0010: int_out = {12'h1, afl[22:20]};	
	8'b1000_0011: int_out = {11'h1, afl[22:19]};	
	8'b1000_0100: int_out = {10'h1, afl[22:18]};	
	8'b1000_0101: int_out =  {9'h1, afl[22:17]};	
	8'b1000_0110: int_out =  {8'h1, afl[22:16]};	
	8'b1000_0111: int_out =  {7'h1, afl[22:15]};	
	8'b1000_1000: int_out =  {6'h1, afl[22:14]};	
	8'b1000_1001: int_out =  {5'h1, afl[22:13]};	
	8'b1000_1010: int_out =  {4'h1, afl[22:12]};	
	8'b1000_1011: int_out =  {3'h1, afl[22:11]};	
	8'b1000_1100: int_out =  {2'h1, afl[22:10]};	
	8'b1000_1101: int_out =  {1'h1, afl[22: 9]};	
	default:      int_out = 15'h7fff;		
      endcase
    end
  end
  
  
  always @(posedge clk) begin
    if(afl[31]) fx_int <= ~int_out + 16'h1;
    else        fx_int <=  {1'b0, int_out};
  end
  
endmodule