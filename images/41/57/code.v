module top_module(input a, b, c, input clk, output reg out);reg and_out;
  reg or_out;
  reg and_in1;
  reg and_in2;
  reg or_in1;
  reg or_in2;
  
  always @(*) begin
    and_in1 = a & b;
    and_in2 = and_out & c;
    or_in1 = and_in1;
    or_in2 = or_out;
  end
  
  always @(posedge clk) begin
    and_out <= and_in1 & and_in2;
    or_out <= or_in1 | or_in2;
    out <= and_out | or_out;
  end
endmodule