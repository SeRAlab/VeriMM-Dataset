module top_module(
  input clk,
  input reset,
  output reg [3:0] count,
  output reg done,
  output reg overflow
);parameter IDLE = 2'b00, COUNTING = 2'b01, RESET = 2'b10;
  reg [1:0] state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      count <= 4'b0;
      done <= 1'b0;
      overflow <= 1'b0;
      state <= RESET;
    end
    else begin
      state <= next_state;
      case (state)
        IDLE: begin
          count <= 4'b0;
          done <= 1'b0;
          overflow <= 1'b0;
          if (clk) next_state <= COUNTING;
          else next_state <= IDLE;
        end
        COUNTING: begin
          if (count == 4'b1001) begin
            done <= 1'b1;
            next_state <= IDLE;
          end
          else begin
            count <= count + 1;
            next_state <= COUNTING;
          end
        end
        RESET: begin
          count <= 4'b0;
          done <= 1'b0;
          overflow <= 1'b0;
          if (reset) next_state <= RESET;
          else next_state <= COUNTING;
        end
        default: next_state <= IDLE;
      endcase
      if (count == 4'b1001) overflow <= 1'b1;
      else overflow <= 1'b0;
    end
  end
endmodule