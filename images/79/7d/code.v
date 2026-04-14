module top_module(
  input [3:0] data_in,
  input shift,
  output [3:0] data_out
);reg [3:0] shift_reg = 4'b0000;

  always @(*) begin
    if (shift == 0) begin
      shift_reg <= data_in;
    end else begin
      if (shift == 1) begin
        if (shift_reg[3] == 1) begin
          shift_reg <= {shift_reg[2:0], 1'b0};
        end else begin
          shift_reg <= {shift_reg[2:0], shift_reg[3]};
        end
      end else begin
        shift_reg <= shift_reg;
      end
    end
  end

  assign data_out = shift_reg;

endmodule