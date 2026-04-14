module top_module(
  input clk,
  input reset, // Synchronous active-high reset
  input [11:0] d, // 12-bit input for multiplication
  input select, // Select input to choose between multiplication and shift register
  output reg [7:0] q // 8-bit output from the shift register
);reg [11:0] mult_out; // Output from the multiplier
  reg [7:0] shift_reg = 8'd0; // 8-bit shift register with active high synchronous reset

  // Multiplier module
  always @ (posedge clk) begin
    if (reset) begin
      mult_out <= 12'd0;
    end else begin
      mult_out <= d * 5;
    end
  end

  // Control logic module
  always @ (posedge clk) begin
    if (reset) begin
      shift_reg <= 8'd0;
    end else begin
      if (select) begin // Shift register operation
        shift_reg <= {shift_reg[6:0], mult_out[7:0]};
      end else begin // Multiplication operation
        shift_reg <= 8'd0;
      end
    end
  end

  // Output module
  always @ (posedge clk) begin
    if (reset) begin
      q <= 8'd0;
    end else begin
      q <= shift_reg;
    end
  end

endmodule