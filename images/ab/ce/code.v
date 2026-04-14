module top_module(
  input clk, reset,
  output reg [SIZE-1:0] out
);parameter SIZE = 4;

  reg [SIZE-1:0] state;

  always @(posedge clk, posedge reset)
    begin
      if (reset) begin
        state <= 0;
        out <= 0;
      end
      else begin
        state <= {state[SIZE-2:0], (state[SIZE-1] ^ state[SIZE-2])}; // Fixed the bit width issue here
        out <= state;
      end
    end

endmodule