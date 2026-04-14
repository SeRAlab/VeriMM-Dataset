module top_module( 
  input in0, in1, in2, in3, d0, d1, d2, d3, clk, reset,
  output reg out0, out1, out2, out3 // Changed to reg type
);wire n1, n2, n3, n4;

  // Implementing NOR gates
  wire nor_out3 = ~(in2 | in3) & d3;
  wire nor_out2 = ~(in0 | in1) & d2;
  wire nor_out1 = ~(in2 | in3) & d1;
  wire nor_out0 = ~(in0 | in1) & d0;

  // Implementing flip-flops with always block
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out3 <= 1'b0;
      out2 <= 1'b0;
      out1 <= 1'b0;
      out0 <= 1'b0;
    end else begin
      out3 <= nor_out3;
      out2 <= nor_out2;
      out1 <= nor_out1;
      out0 <= nor_out0;
    end
  end

  // Implementing NOR gates for reset signal (removed as now implemented in the flip-flops)
  
  // Implementing MUX gates
  assign n1 = (d3) ? in3 : in2;
  assign n2 = (d2) ? in1 : in0;
  assign n3 = (d1) ? in3 : in2;
  assign n4 = (d0) ? in1 : in0;
  
endmodule