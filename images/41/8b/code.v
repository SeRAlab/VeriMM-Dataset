module top_module(in0, in1, in2, in3, d0, d1, d2, d3, out0, out1, out2, out3, clk, reset);input in0, in1, in2, in3, d0, d1, d2, d3, clk, reset;
  output out0, out1, out2, out3;
  wire   out0205, out1211, out2217, out3223, n1, n2, n3, n4;

  // Replace DFFPOSX1 with a standard D flip-flop implementation
  reg out0_reg, out1_reg, out2_reg, out3_reg;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out0_reg <= 1'b0;
      out1_reg <= 1'b0;
      out2_reg <= 1'b0;
      out3_reg <= 1'b0;
    end else begin
      out0_reg <= out0205;
      out1_reg <= out1211;
      out2_reg <= out2217;
      out3_reg <= out3223;
    end
  end
  
  assign out0 = out0_reg;
  assign out1 = out1_reg;
  assign out2 = out2_reg;
  assign out3 = out3_reg;

  // Replace NOR2X1 with standard logic gates
  assign n1 = ~(reset | (in2 & d3)); // changed logic to use simple gates
  assign n2 = ~(reset | (in0 & d2));
  assign n3 = ~(reset | (in2 & d1));
  assign n4 = ~(reset | (in0 & d0));

  // Replace MUX2X1 with simple assignments
  assign out3223 = (d3 ? in3 : in2); 
  assign out2217 = (d2 ? in1 : in0); 
  assign out1211 = (d1 ? in3 : in2); 
  assign out0205 = (d0 ? in1 : in0); 

endmodule