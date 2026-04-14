module top_module(in0, in1, in2, in3, d0, d1, d2, d3, out0, out1, out2, out3, clk, reset);input in0, in1, in2, in3, d0, d1, d2, d3, clk, reset;
  output out0, out1, out2, out3;
  wire n1, n2, n3, n4;

  // Internal wire declarations for flip-flops
  reg out0_reg, out1_reg, out2_reg, out3_reg;

  // Combinational logic
  assign n1 = (d0 ? in1 : in0);
  assign n2 = (d1 ? in3 : in2);
  assign n3 = (d2 ? in1 : in0);
  assign n4 = (d3 ? in3 : in2);
  
  // Sequential logic
  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      out0_reg <= 1'b0;
      out1_reg <= 1'b0;
      out2_reg <= 1'b0;
      out3_reg <= 1'b0;
    end else begin
      out0_reg <= ~(reset | n1); // NOR functionality
      out1_reg <= ~(reset | n2); // NOR functionality
      out2_reg <= ~(reset | n3); // NOR functionality
      out3_reg <= ~(reset | n4); // NOR functionality
    end
  end
  
  // Assign outputs from registers
  assign out0 = out0_reg;
  assign out1 = out1_reg;
  assign out2 = out2_reg;
  assign out3 = out3_reg;

endmodule