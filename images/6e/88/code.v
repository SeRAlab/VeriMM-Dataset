module top_module(
    input [1:0] in,
    output reg [3:0] out
  );localparam WIDTH = 2'h2;
  
  
  integer i;
  
  always @* begin
    for (i = 1'h0; i < 3'h4; i = i + 1) begin
      if (in == i) begin
        out[(i)*1+0-:1] = 1'h1;
      end else begin
        out[(i)*1+0-:1] = 1'h0;
      end
    end
  end
endmodule