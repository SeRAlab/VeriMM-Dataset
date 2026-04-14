module top_module(
  input clk,
  input reset,
  output reg [1:0] state
);parameter IDLE = 2'b00;
  parameter COUNT = 2'b01;
  parameter DONE = 2'b10;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          state <= COUNT;
        end
        COUNT: begin
          if (state == 2'b11) begin
            state <= DONE;
          end else begin
            state <= state + 1;
          end
        end
        DONE: begin
          state <= IDLE;
        end
      endcase
    end
  end

endmodule