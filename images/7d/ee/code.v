module top_module(
  input [n-1:0] in,
  input clk,
  input reset,
  output [m-1:0] out
);parameter n = 8; // number of input signals
parameter m = 8; // number of output signals
parameter w = 8; // width of each shift register
parameter k = 4; // number of shift registers in the block

reg [w-1:0] shift_registers [k-1:0];

integer i;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    for (i = 0; i < k; i = i + 1) begin
      shift_registers[i] <= 0;
    end
  end else begin
    shift_registers[0] <= {shift_registers[0][w-2:0], in};
    for (i = 1; i < k; i = i + 1) begin
      shift_registers[i] <= {shift_registers[i][w-2:0], shift_registers[i-1][w-1]};
    end
  end
end

assign out = {shift_registers[0][w-1], shift_registers[1][w-1], shift_registers[2][w-1], shift_registers[3][w-1]};

endmodule