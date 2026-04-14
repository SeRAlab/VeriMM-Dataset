module top_module(
    input inp0,
    input inp1,
    input s0,
    output reg out
  );always @* begin
    out = (inp0 & (~s0)) | (inp1 & s0);
  end
endmodule