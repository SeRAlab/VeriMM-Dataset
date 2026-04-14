module top_module(n, ena, e);input [4:0] n;
  input ena;
  output [31:0] e;
  
  function [31:0] decoder;
    input [4:0] n;
    input ena;
    if(ena == 1'b0) decoder = 32'h00000000;
    else begin
      case(n)
       5'b00000: decoder = 32'h00000001;
       5'b00001: decoder = 32'h00000002;
       5'b00010: decoder = 32'h00000004;
       5'b00011: decoder = 32'h00000008;
       5'b00100: decoder = 32'h00000010;
       5'b00101: decoder = 32'h00000020;
       5'b00110: decoder = 32'h00000040;
       5'b00111: decoder = 32'h00000080;
       5'b01000: decoder = 32'h00000100;
       5'b01001: decoder = 32'h00000200;
       5'b01010: decoder = 32'h00000400;
       5'b01011: decoder = 32'h00000800;
       5'b01100: decoder = 32'h00001000;
       5'b01101: decoder = 32'h00002000;
       5'b01110: decoder = 32'h00004000;
       5'b01111: decoder = 32'h00008000;
       5'b10000: decoder = 32'h00010000;
       5'b10001: decoder = 32'h00020000;
       5'b10010: decoder = 32'h00040000;
       5'b10011: decoder = 32'h00080000;
       5'b10100: decoder = 32'h00100000;
       5'b10101: decoder = 32'h00200000;
       5'b10110: decoder = 32'h00400000;
       5'b10111: decoder = 32'h00800000;
       5'b11000: decoder = 32'h01000000;
       5'b11001: decoder = 32'h02000000;
       5'b11010: decoder = 32'h04000000;
       5'b11011: decoder = 32'h08000000;
       5'b11100: decoder = 32'h10000000;
       5'b11101: decoder = 32'h20000000;
       5'b11110: decoder = 32'h40000000;
       5'b11111: decoder = 32'h80000000;
    endcase
    end
  endfunction
  assign e = decoder(n, ena);
endmodule