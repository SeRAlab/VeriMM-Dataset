module top_module(
  input clk,
  input reset,
  input data,
  output reg done
);parameter IDLE = 2'b00;
  parameter COUNTING = 2'b01;
  parameter DONE = 2'b10;

  reg [1:0] state;
  reg [2:0] count;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      count <= 0;
      done <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (data) begin
            state <= COUNTING;
            count <= 1;
          end
        end

        COUNTING: begin
          if (data) begin
            count <= count + 1;
            if (count == 5) begin
              state <= DONE;
              done <= 1;
            end
          end else begin
            state <= DONE;
            done <= 1;
          end
        end

        DONE: begin
          if (!data) begin
            state <= IDLE;
            count <= 0;
            done <= 0;
          end
        end
      endcase
    end
  end
endmodule