module top_module(
  input [bus_size-1:0] input_bus,
  input [shift_amount_size-1:0] shift_amount,
  input shift_direction,
  output [bus_size-1:0] output_bus
);parameter bus_size = 8; // size of input and output bus
parameter shift_amount_size = 3; // number of bits needed to represent shift_amount

reg [bus_size-1:0] shifted_bus; // temporary register to store shifted bus

always @(*) begin
  if (shift_direction == 1) // left shift
    shifted_bus = input_bus << shift_amount; // use left shift operator
  else // right shift
    shifted_bus = input_bus >> shift_amount; // use right shift operator
end

assign output_bus = shifted_bus;

endmodule