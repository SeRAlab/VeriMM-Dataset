module top_module(
  input CLK,
  input RST,
  input SHIFT,
  input LOAD,
  input [7:0] DATA_IN,
  input DATA_IN_VALID,
  output reg [7:0] DATA_OUT,
  output reg DATA_OUT_VALID
);reg [7:0] shift_reg;

  always @(posedge CLK) begin
    if (RST) begin
      shift_reg <= 8'b0;
      DATA_OUT_VALID <= 1'b0;
    end
    else begin
      if (LOAD) begin
        shift_reg <= DATA_IN;
        DATA_OUT_VALID <= DATA_IN_VALID;
      end
      else if (SHIFT) begin
        shift_reg <= {shift_reg[6:0], shift_reg[7]};
        DATA_OUT_VALID <= 1'b1;
      end
      else begin
        DATA_OUT_VALID <= 1'b1;
      end
    end
    DATA_OUT <= shift_reg;
  end

endmodule