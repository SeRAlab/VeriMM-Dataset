module top_module(
     clk, reset, en,
     out, empty, full
  );parameter integer MIN = 0;
  parameter integer MAX = 255;
  parameter integer INC = 1;    

  input clk, reset, en;
  output integer out;
  output reg empty; 
  output reg full; 

  always @(posedge clk)
    if (reset) begin
      out <= MIN;
      full <= 0;
      empty <= 0;
    end else if (en) begin
      full  <= (out == MAX - INC);
      empty <= (out == MAX);
      out   <= (out == MAX) ? MIN : out + INC;
    end else begin
      
      full <= 0;
      empty <= 0;
    end

endmodule