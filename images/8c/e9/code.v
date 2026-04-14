module johnson_counter (
  input clk,
  input reset,
  output reg [1:0] state
);always @(posedge clk or posedge reset) begin
    if (reset)
        state <= 2'b00;
    else
        state <= {state[0], ~state[1]};
end

endmodule