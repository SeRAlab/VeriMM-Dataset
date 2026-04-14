module top_module(
  input clk,       // Added clk input
  input in,
  output out
);reg delay_line;

  always @(posedge clk) begin
    delay_line <= in;
  end

  assign out = (in == delay_line) ? in : delay_line;

endmodule