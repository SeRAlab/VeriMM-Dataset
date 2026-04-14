module shift_reg_3bit(
  input clk,
  input serial_in,
  output reg [2:0] parallel_out
);

  always @(posedge clk) begin
    parallel_out <= {serial_in, parallel_out[2:1]};
  end

endmodule