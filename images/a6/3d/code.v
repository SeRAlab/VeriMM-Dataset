module top_module(
  input clk,
  input reset,
  input shift_left,
  input shift_right,
  input [7:0] data_in,
  output reg [7:0] data_out  // Changed to reg since it's assigned in always block
);reg [7:0] register;

  // Removed the dual_edge_ff instance as it is unknown

  always @ (posedge clk or negedge reset) begin
    if (!reset) begin
      register <= 8'b0;
    end else begin
      if (shift_left) begin
        register <= {register[6:0], 1'b0}; // Shift left and fill LSB with 0
      end else if (shift_right) begin
        register <= {1'b0, register[7:1]}; // Shift right and fill MSB with 0
      end else begin
        register <= data_in; // Capture data_in if no shift
      end
    end
  end

  assign data_out = register;

endmodule