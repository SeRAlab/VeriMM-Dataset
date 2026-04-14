module top_module(
  input clk,
  input data,
  output reg [3:0] q,
  output reg [3:0] difference
);reg [3:0] q_temp;

  always @(posedge clk) begin
    q_temp <= {q[2:0], data};
    q <= q_temp;
  end

  always @(posedge clk) begin
    difference <= q[1] - q[0];
  end

endmodule