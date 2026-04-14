module top_module( in0, in1, in2, in3, d0, d1, d2, d3, out0, out1, out2, out3, 
        clk, reset );input in0, in1, in2, in3, d0, d1, d2, d3, clk, reset;
  output out0, out1, out2, out3;
  wire   out0205, out1211, out2217, out3223, n1, n2, n3, n4;

  // Use standard Verilog flip-flop, if DFFPOSX1 is not available
  reg out0, out1, out2, out3;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out0 <= 1'b0;
      out1 <= 1'b0;
      out2 <= 1'b0;
      out3 <= 1'b0;
    end else begin
      out3 <= out3223;
      out2 <= out2217;
      out1 <= out1211;
      out0 <= out0205;
    end
  end

  assign out3223 = reset ? 1'b0 : (d3 ? in3 : in2);
  assign out2217 = reset ? 1'b0 : (d2 ? in1 : in0);
  assign out1211 = reset ? 1'b0 : (d1 ? in3 : in2);
  assign out0205 = reset ? 1'b0 : (d0 ? in1 : in0);

endmodule