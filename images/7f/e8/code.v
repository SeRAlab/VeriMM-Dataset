module binary_counter_16bit(
  input clk,
  input rst_n,
  output reg [15:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      count <= 16'b0000000000000000;
    else
      count <= count + 1;
  end

endmodule