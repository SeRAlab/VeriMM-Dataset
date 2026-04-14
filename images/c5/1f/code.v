module encryption_module(
  input aclk,
  input reset,
  input [15:0] data_in,
  output reg [15:0] data_out
);

  reg [7:0] A;
  reg [7:0] B;
  reg [7:0] rotated_A;
  reg [15:0] result;

  always @(posedge aclk) begin
    if (reset) begin
      A <= 8'd0;
      B <= 8'd0;
      rotated_A <= 8'd0;
      result <= 16'd0;
      data_out <= 16'd0;
    end else begin
      A <= data_in[15:8];
      B <= data_in[7:0];

      rotated_A <= {A[5:0], A[7:6]};
      result <= rotated_A + B;
      data_out <= {result[15:8], result[7:0]};
    end
  end

endmodule