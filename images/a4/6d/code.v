module top_module(
  input [n-1:0] bus_in,
  input en,
  output reg [n-1:0] bus_out // Change to reg type to allow assignment in always blocks
);parameter n = 8; // width of the bus

reg [n-1:0] hold_reg;
reg [n-1:0] feedback_reg;

always @(posedge en) begin
  hold_reg <= bus_in;
  feedback_reg <= bus_out; // This line should be modified to avoid using bus_out before it is assigned
end

always @(negedge en) begin
  bus_out <= feedback_reg;
end

always @(posedge en) begin
  bus_out <= hold_reg;
end

endmodule