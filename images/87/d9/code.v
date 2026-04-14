module binary_counter_3bit(
  input clk,
  input rst_n,
  output reg [2:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      count <= 3'b000;
    else
      count <= count + 1;
  end

endmodule