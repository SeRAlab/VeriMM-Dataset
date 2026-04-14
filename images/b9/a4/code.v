module top_module(
  input clock,
  input reset,
  output reg [1:0] state_out,
  output reg done
);parameter COUNT_TO_DONE = 3;

  localparam IDLE = 2'b00;
  localparam COUNT = 2'b01;
  localparam DONE = 2'b10;

  reg [1:0] state;

  always @(posedge clock or negedge reset) begin
    if (~reset) begin
      state <= IDLE;
      state_out <= IDLE;
      done <= 0;
    end
    else begin
      case (state)
        IDLE: begin
          if (clock) begin
            state <= COUNT;
            state_out <= COUNT;
          end
        end
        COUNT: begin
          if (clock) begin
            if (state_out == COUNT_TO_DONE) begin
              state <= DONE;
              state_out <= DONE;
              done <= 1;
            end
            else begin
              state_out <= state_out + 1;
            end
          end
        end
        DONE: begin
          if (clock) begin
            done <= 1;
          end
        end
      endcase
    end
  end

endmodule