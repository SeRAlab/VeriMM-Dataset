module top_module(n, ena, e);input [3:0] n;
  input ena;
  output reg [15:0] e;
  
  function [15:0] decoder;
    input [3:0] n;
    input ena;
    if(ena == 1'b0) decoder = 16'h0000;
    else begin
      case(n)
       4'b0000: decoder = 16'h0001;
       4'b0001: decoder = 16'h0002;
       4'b0010: decoder = 16'h0004;
       4'b0011: decoder = 16'h0008;
       4'b0100: decoder = 16'h0010;
       4'b0101: decoder = 16'h0020;
       4'b0110: decoder = 16'h0040;
       4'b0111: decoder = 16'h0080;
       4'b1000: decoder = 16'h0100;
       4'b1001: decoder = 16'h0200;
       4'b1010: decoder = 16'h0400;
       4'b1011: decoder = 16'h0800;
       4'b1100: decoder = 16'h1000;
       4'b1101: decoder = 16'h2000;
       4'b1110: decoder = 16'h4000;
       4'b1111: decoder = 16'h8000;
      endcase
    end
  endfunction
  
  always @(*) begin
    e = decoder(n, ena);
  end
  
endmodule