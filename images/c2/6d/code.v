module mux4 (dout, in0, in1, sel0, sel1);

  output dout;
  input in0, in1, sel0, sel1;

  reg dout;

  always @ (sel1 or sel0 or in0 or in1) begin
    case ({sel1, sel0})
      2'b00: dout = 1'b0;
      2'b01: dout = in0;
      2'b10: dout = in1;
      2'b11: dout = 1'bx;
    endcase
  end

endmodule