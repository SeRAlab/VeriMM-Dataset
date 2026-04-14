module top_module(input a, b, output reg out);// Change the output to output reg
  always @(*) begin
    case ({a, b})
      2'b00: out = 1'b0;
      2'b01: out = 1'b1;
      2'b10: out = 1'b1;
      2'b11: out = 1'b0;
    endcase
  end
endmodule