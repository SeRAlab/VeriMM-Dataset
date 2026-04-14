module top_module(output reg [1:0] state, input x, y, Clk);initial state = 2'b00; 
  always @ (posedge Clk) begin 
  case ({x,y}) 
  2'b00: begin if (state == 2'b00) state <= state; 
  else if (state == 2'b01) state <= 2'b10; 
  else if (state == 2'b10) state <= 2'b00; 
  else state <= 2'b10; 
  end 
  2'b01: begin if (state == 2'b00) state <= state; 
  else if (state == 2'b01) state <= 2'b11; 
  else if (state == 2'b10) state <= 2'b00; 
  else state <= state; 
  end 
  2'b10: begin if (state == 2'b00) state <= 2'b01; 
  else if (state == 2'b01) state <= 2'b10; 
  else if (state == 2'b10) state <= state; 
  else state <= 2'b00; 
  end 
  2'b11: begin if (state == 2'b00) state <= 2'b01; 
  else if (state == 2'b01) state <= 2'b11; 
  else if (state == 2'b10) state <= 2'b11; 
  else state <= 2'b00; 
  end 
  endcase 
  end 
 endmodule