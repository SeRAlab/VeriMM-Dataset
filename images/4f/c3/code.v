module top_module(
	   wager_o,
	   mih_o,
	   
	   wager_b,
	   mih_b
	   );input wire [15:0] wager_o;
   input wire [15:0] mih_o;
   output wire [15:0] wager_b;
   output wire [15:0] mih_b;
   
   assign wager_b = bcd(wager_o);
   assign mih_b = bcd(mih_o);

   function [15:0] bcd;
      input [15:0]    input_b;
      reg [15:0]     b1000;
      reg [15:0]     b100;
      reg [15:0]     b10;
      reg [15:0]     b1;
      
      begin
	 b1000 = input_b / 16'd1000;
	 b100 = input_b % 16'd1000 / 16'd100;
	 b10 = input_b % 16'd1000 % 16'd100 / 16'd10;
	 b1 = input_b % 16'd1000 % 16'd100 % 16'd10 / 16'd1;

	 bcd[15:12] = b1000[3:0];
	 bcd[11:8] = b100[3:0];
	 bcd[7:4] = b10[3:0];
	 bcd[3:0] = b1[3:0];
      end
   endfunction
endmodule