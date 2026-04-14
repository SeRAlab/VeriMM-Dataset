module top_module(
  input clk,
  input reset,
  input control,
  input [31:0] data_in,
  output reg [31:0] data_out
);reg [31:0] state;

always @(posedge clk) begin
  if (reset) begin
    state <= 32'h1;
    data_out <= 32'h1;
  end else if (control) begin
    state <= {state[30:0], state[31] ^ state[21] ^ state[1] ^ state[0]};
    data_out <= state;
  end
end

endmodule