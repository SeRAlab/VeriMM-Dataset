module top_module(
  input [3:0] binary_in,
  input clk,
  input reset,
  output reg [2:0] ones_count
);// Combinational always block
always @(*) begin
  ones_count = binary_in[0] + binary_in[1] + binary_in[2] + binary_in[3];
end

// Sequential always block with reset signal
always @(posedge clk or posedge reset) begin
  if (reset) begin
    ones_count <= 3'b0;
  end else begin
    ones_count <= binary_in[0] + binary_in[1] + binary_in[2] + binary_in[3];
  end
end

endmodule