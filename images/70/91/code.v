module top_module(
  input [3:0] in,
  output reg [1:0] pos
);always @*
  begin
    case(in)
      4'b0001: pos = 0;
      4'b0010: pos = 1;
      4'b0100: pos = 2;
      4'b1000: pos = 3;
      default: pos = 0;
    endcase
  end
  
endmodule