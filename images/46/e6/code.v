module top_module(
  input [n-1:0] in,
  input shift,
  output reg [m-1:0] out
);// Parameters for configuring the sizes
parameter m = 8; // Number of output signals
parameter n = 8; // Number of input signals, assuming equal size for illustration

// Serial Shift Register
reg [m-1:0] serial_reg;
always @(posedge shift) begin
  serial_reg <= {serial_reg[m-2:0], in[0]};
end
assign out = serial_reg;

// Parallel Shift Register
reg [m-1:0] parallel_reg;
always @(posedge shift) begin
  parallel_reg <= in;
end

// Left Shift Register
reg [m-1:0] left_reg;
always @(posedge shift) begin
  left_reg <= {left_reg[m-2:0], in[0]};
end

// Right Shift Register
reg [m-1:0] right_reg;
always @(posedge shift) begin
  right_reg <= {in[n-1], right_reg[m-1:1]};
end

endmodule