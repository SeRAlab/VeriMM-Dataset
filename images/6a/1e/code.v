module top_module(
  input clk,                // Added clock input
  input load,               // Added load signal input
  input [n-1:0] ctrl,
  input [r-1:0] new_values, // Added new_values input
  output [m-1:0] out
);parameter n = 4; // number of control signals
parameter m = 2; // number of output signals
parameter r = 4; // number of registers

reg [r-1:0] reg_values; // register values

// Control logic to load new values into the registers
always @ (posedge clk) begin
  if (load) begin
    reg_values <= new_values;
  end
end

// Control logic to output the current register values to the output signals
assign out = reg_values[m-1:0]; // Ensure to assign the correct bits from reg_values

endmodule