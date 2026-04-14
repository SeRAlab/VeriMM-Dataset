module top_module(
  input clk,
  input data,
  output reg Q,
  output reg Q_bar
);reg d1, d2;
  wire and1_out, and2_out;

  always @(posedge clk) begin
    d1 <= data;
  end
  
  always @(negedge clk) begin
    d2 <= d1;
  end
  
  assign and1_out = d1 & ~Q_bar;
  assign and2_out = d2 & ~Q;
  
  always @(*) begin
    Q <= and2_out;
    Q_bar <= and1_out;
  end
  
endmodule