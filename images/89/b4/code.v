module top_module(
    input wire clk,
    input wire [11:0] xpos_in,
    input wire [11:0] ypos_in,
    input wire mouseleft_in,
    input wire rst,
    
    output reg [11:0] xpos_out,
    output reg [11:0] ypos_out,
    output reg mouseleft_out
    );always @(posedge clk)
    begin
       if (rst)
        begin   
          xpos_out <= 0;
          ypos_out <= 0;   
          mouseleft_out <= 0;  
        end
      else 
        begin
           xpos_out <= xpos_in;
           ypos_out <= ypos_in;   
           mouseleft_out <= mouseleft_in; 
        end
    end   
    
endmodule