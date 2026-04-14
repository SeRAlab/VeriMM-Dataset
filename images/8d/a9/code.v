module top_module(
  output up,
  output down,
  input clk,
  input freeze,
  input [1:0] tach);reg [1:0] last = 0;
  reg u = 0;
  reg d = 0;
  
  
  wire [3:0] encodedstate; 
  
  
  assign encodedstate = {tach, last};
  assign up = u;
  assign down = d;
  
  always @(posedge clk) begin
    u <= 0;
    d <= 0;
    if(~freeze) begin
      case(encodedstate) 
        4'b0000, 
        4'b1111,
        4'b1010,
        4'b0101:
          begin
          end
        4'b0100, 
        4'b1101,
        4'b1011,
        4'b0010:
          begin
            last <= tach;
            u <= 1;
            d <= 0;  
          end
        4'b0001, 
        4'b0111,
        4'b1110,
        4'b1000:
          begin
            last <= tach;
          	u <= 0;
            d <= 1;
          end
        4'b0011, 
        4'b1100,
        4'b0110,
        4'b1001:
          begin
          end 
        
        default: 
          begin
          	u <= 1'bx;
          	d <= 1'bx;
          end
      endcase    
    end  
  end
  
  
endmodule