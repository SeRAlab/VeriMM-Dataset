module top_module(sel1, sel0, in0, in1, in2, in3, out);input sel1, sel0, in0, in1, in2, in3;
  output reg out; // Change wire to reg

  always @ (*) begin
    case ({sel1, sel0})
      2'b00: out = in0;
      2'b01: out = in1;
      2'b10: out = in2;
      2'b11: out = in3;
      default: out = 1'b0; // Optional: define a default case
    endcase
  end

endmodule