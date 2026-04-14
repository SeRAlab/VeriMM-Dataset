module top_module(
  input clk,
  input reset,
  input a,
  input b,
  output reg x,
  output reg y
);parameter S0 = 3'b001;
  parameter S1 = 3'b010;
  parameter S2 = 3'b100;

  reg [2:0] state, next_state;

  always @(*) begin
    case(state)
      S0: begin
        if(a == 1) next_state = S1;
        else next_state = S0;
      end
      S1: begin
        if(b == 0) next_state = S2;
        else next_state = S0;
      end
      S2: begin
        if(a == 1) next_state = S1;
        else next_state = S2;
      end
    endcase
  end

  always @(*) begin
    case(state)
      S0: begin
        x = 0;
        y = 0;
      end
      S1: begin
        x = 1;
        y = 0;
      end
      S2: begin
        x = 0;
        y = 1;
      end
    endcase
  end

  always @(posedge clk, posedge reset) begin
    if(reset) state <= S0;
    else state <= next_state;
  end

endmodule