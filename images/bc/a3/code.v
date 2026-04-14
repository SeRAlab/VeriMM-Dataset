module top_module(
    input [2:0] in,
    output reg [2:0] out
  );localparam VECTABLE = 24'hfac688;
  
  always @* begin
    out = VECTABLE[(in)*3+2-:3];
  end
endmodule