module top_module(
  input clk, reset, ena,
  output reg [SIZE-1:0] out
);parameter SIZE = 4;
  reg [SIZE-1:0] state;
  always @(posedge clk or negedge reset)
    begin
      if(!reset)
        state <= 0;
      else if(ena)
        state <= {state[SIZE-2:0], state[SIZE-1]^state[SIZE-2]};
    end
  assign out = state;
endmodule