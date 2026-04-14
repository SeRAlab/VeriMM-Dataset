module top_module(input a, b, c, output reg out);always @ (a, b, c) begin
    out = (a ^ b) ^ c;
  end

endmodule