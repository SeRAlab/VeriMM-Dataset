module top_module(
  input clk,
  input reset,
  input [15:0] data_in,
  input valid_a,
  input ready_b,
  input [3:0] threshold,
  output ready_a,
  output reg valid_b,
  output reg [17:0] data_out
);reg [17:0] accumulator;
  reg [3:0] count;

  assign ready_a = !valid_b;

  always @(posedge clk) begin
    if (reset) begin
      accumulator <= 0;
      count <= 0;
      valid_b <= 0;
    end else begin
      if (valid_a && ready_b) begin
        accumulator <= accumulator + data_in;
        count <= count + 1;
        if (count == threshold) begin
          valid_b <= 1;
        end
      end
    end
  end

  reg parity_bit;
  assign parity_bit = ^accumulator[15:0];

  always @(posedge clk) begin
    if (reset) begin
      data_out <= 0;
    end else begin
      if (valid_b && ready_a) begin
        data_out <= {accumulator, parity_bit & 1'b1};
      end
    end
  end

endmodule