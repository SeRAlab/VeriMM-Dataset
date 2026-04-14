module top_module(
  input clk,
  input reset,
  input [3:0] data,
  output reg out,
  output reg [3:0] shift_out
);reg [3:0] shift_reg;
  wire [3:0] shifted_data;
  wire equal_data;

  // Shift register implementation using D flip-flops
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      shift_reg <= 4'b0000;
    end else begin
      shift_reg <= {shift_reg[2:0], data[3]};
    end
  end
  
  // Output the shifted data
  assign shift_out = shift_reg;

  // Comparator implementation using XOR and AND gates
  assign shifted_data = {shift_reg[2:0], 1'b0};
  assign equal_data = (shifted_data ^ data) == 4'b0000;
  always @(equal_data) begin
    if (equal_data) begin
      out <= 1'b1;
    end else begin
      out <= 1'b0;
    end
  end

endmodule