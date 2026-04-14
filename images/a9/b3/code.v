module shift_register
(
  input clk,
  input load,
  input [3:0] parallel_in,

  output reg serial_out
);

  reg [3:0] data;

  always @(posedge clk) begin
    if (load)
      data <= parallel_in;
    else
      data <= {1'b0, data[3:1]};
    serial_out <= data[0];
  end

endmodule