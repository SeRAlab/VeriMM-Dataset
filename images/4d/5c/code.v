module shift_register(
  input clk,
  input rst_n,
  input serial_in,
  output reg [7:0] parallel_out
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      parallel_out <= 8'b00000000;
    else
      parallel_out <= {parallel_out[6:0], serial_in};
  end

endmodule