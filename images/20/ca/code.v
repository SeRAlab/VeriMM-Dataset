module simple_rnn (  
    input clk,  
    input reset,  
    input [3:0] x,  
    output reg [3:0] y  
);  
  reg [3:0] previous_y;  

  always @(posedge clk or posedge reset) begin  
    if (reset) begin  
      previous_y <= 4'b0000;  
      y <= 4'b0000;  
    end else begin  
      previous_y <= y;  
      y <= (previous_y + x) & 4'b1111;  
    end  
  end  
endmodule