module top_module(
  input clk,
  input [7:0] data_in,
  output reg parity
);reg [7:0] shift_reg;
  reg [7:0] shifted_data;
  reg [7:0] sum;
  reg [2:0] i;

  always @(posedge clk) begin
    shift_reg <= {shift_reg[6:0], data_in};
    shifted_data <= {shift_reg[5:0], 2'b00};
    sum <= shifted_data + shift_reg;
    parity <= 1'b1;

    for (i = 0; i < 8; i = i + 1) begin
      if (sum[i] == 1'b1) begin
        parity <= ~parity;
      end
    end
  end

endmodule