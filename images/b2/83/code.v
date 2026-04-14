module top_module(
    output reg [4:0] out,
    input [4:0] aLUFN
  );always @* begin
    out = aLUFN;
  end
endmodule