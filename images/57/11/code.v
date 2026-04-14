module top_module(
  input clk,
  input reset,
  input load,
  input [7:0] data,
  output reg [7:0] shifted_data
);reg [7:0] shift_reg;

  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      shift_reg <= 8'b0;
      shifted_data <= 8'b0;
    end else begin
      if (load) begin
        shift_reg <= data;
        shifted_data <= data;
      end else begin
        shift_reg <= {shift_reg[6:0], 1'b0};
        shifted_data <= shift_reg;
      end
    end
  end

endmodule