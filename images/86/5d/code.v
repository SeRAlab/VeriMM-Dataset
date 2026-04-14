module top_module(
    input clk,
    input rst,
    input [1:0] m,
    output reg [1:0] mode
  );always @* begin
    
    case (m)
      2'h1: begin
        mode[0+0-:1] = 1'h1;
        mode[1+0-:1] = 1'h0;
      end
      2'h2: begin
        mode[0+0-:1] = 1'h0;
        mode[1+0-:1] = 1'h1;
      end
      default: begin
        mode = 2'h0;
      end
    endcase
  end
endmodule