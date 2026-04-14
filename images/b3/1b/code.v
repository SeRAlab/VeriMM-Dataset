module top_module(input wire test, input wire [BITS:0] ifZero, input wire [BITS:0] ifOne, output reg [BITS:0] out);parameter BITS = 31;
always @(*)
  begin
    out = (test == 0 ? ifZero : ifOne); 
  end
endmodule