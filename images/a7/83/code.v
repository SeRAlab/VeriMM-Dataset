module top_module(
          input clk, clear,
          input [7:0] cct_input,
          output reg [7:0] cct_output
			 );reg [7:0] goofy_counter;

always @ (posedge clk)
if (clear == 1'b1) goofy_counter = 8'b10000001;
else if (goofy_counter == 8'b10000001) goofy_counter = 8'b01000010;
else if (goofy_counter == 8'b01000010) goofy_counter = 8'b00100100;
else if (goofy_counter == 8'b00100100) goofy_counter = 8'b00011000;
else if (goofy_counter == 8'b00011000) goofy_counter = 8'b10000001;
else goofy_counter = 8'b10000001;

always @ *
cct_output = goofy_counter;

endmodule