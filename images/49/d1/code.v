module top_module(
  input clk,
  input reset,
  input [3:0] in,
  output reg done
);parameter IDLE = 2'b00, STATE1 = 2'b01, STATE2 = 2'b10;
  reg [1:0] state;
  reg [3:0] shift_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      shift_reg <= 4'b0;
      done <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (in[3] == 1'b1) begin
            shift_reg <= {shift_reg[2:0], in};
            state <= STATE1;
          end
        end
        STATE1: begin
          shift_reg <= {shift_reg[2:0], in};
          if (shift_reg == 4'b1011) begin
            done <= 1;
            state <= IDLE;
          end else begin
            state <= STATE2;
          end
        end
        STATE2: begin
          shift_reg <= {shift_reg[2:0], in};
          if (shift_reg == 4'b1011) begin
            done <= 1;
            state <= IDLE;
          end else begin
            state <= IDLE;
          end
        end
      endcase
    end
  end
endmodule