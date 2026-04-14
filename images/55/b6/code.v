module top_module(
    output [15:0] a,
    input 	      clk,
    input [1:0]       addr_sel,
    input [15:0]      addr0,
    input [15:0]      addr1,
    input [15:0]      addr2,
    input [15:0]      addr3);reg [1:0] 	      sel;

   assign a = (sel == 2'b00 ? addr0 :
	       (sel == 2'b01 ? addr1 :
		(sel == 2'b10 ? addr2 :
		 addr3)));
   
   always @(negedge clk) begin
      sel <= addr_sel;
   end
endmodule