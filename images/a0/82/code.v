module top_module(input wire clk, vgae2, 
                input wire [7:0] e,
                output wire [3:0] num);reg [3:0] aux;
  
  always @(e, vgae2) 
  begin
    if (vgae2) 
    begin
      case (e[3:0])              
        4'b0000: aux = 0;
        4'b0001: aux = 1;
        4'b0010: aux = 2;
        4'b0011: aux = 3;
        4'b0100: aux = 4;
        4'b0101: aux = 5;
        4'b0110: aux = 6;
        4'b0111: aux = 7;
        4'b1000: aux = 8;
        4'b1001: aux = 9;
        default: aux = 15;  
      endcase
    end      
  end

  assign num = aux;

endmodule