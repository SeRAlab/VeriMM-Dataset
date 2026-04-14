module top_module(
  input clk,
  input reset,
  output reg [3:0] count
);parameter IDLE = 2'b00, COUNTING = 2'b01, RESET = 2'b10;
  reg [1:0] state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= RESET;
      count <= 4'b0;
    end
    else begin
      state <= next_state;
      case (state)
        IDLE: begin
          count <= 4'b0;
          if (count == 4'b1001) next_state <= RESET;
          else next_state <= COUNTING;
        end
        COUNTING: begin
          count <= count + 1;
          if (count == 4'b1001) next_state <= RESET;
          else next_state <= COUNTING;
        end
        RESET: begin
          count <= 4'b1001;
          next_state <= IDLE;
        end
      endcase
    end
  end
endmodule