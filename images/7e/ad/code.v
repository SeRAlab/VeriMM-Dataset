module shift_register (
  input clk,
  input reset,
  input enable,
  input data_in,
  output reg [7:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 8'b00000000;
    end
    else if (enable) begin
      q <= {data_in, q[7:1]};
    end
  end

endmodule