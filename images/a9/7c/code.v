module shift_register
(
  input clk,
  input reset,
  input load,
  input [7:0] data_in,
  output reg serial_out
);

  reg [7:0] shift_reg;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      shift_reg <= 8'b0;
      serial_out <= 1'b0;
    end
    else if (load) begin
      shift_reg <= data_in;
      serial_out <= data_in[7];
    end
    else begin
      serial_out <= shift_reg[7];
      shift_reg <= {shift_reg[6:0], 1'b0};
    end
  end

endmodule