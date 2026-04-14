module top_module(
  input start,
  input stopnclear,
  input tick,
  input clk,
  input rst_l,
  output reg busy,
  output reg error
);// States
  parameter IDLE = 2'b00;
  parameter COUNTING = 2'b01;
  parameter OVERFLOW = 2'b10;

  // Count value
  parameter COUNT_MAX = 4'b1010;

  // Registers
  reg [3:0] count_reg;
  reg [1:0] state_reg;

  // Combinational logic
  reg [3:0] count_next; // Changed from wire to reg
  reg [1:0] state_next; // Changed from wire to reg

  // Assign next state and count
  always @(*) begin
    case (state_reg)
      IDLE: begin
        if (start) begin
          state_next = COUNTING;
          count_next = 4'b0000;
        end else begin
          state_next = IDLE;
          count_next = count_reg;
        end
      end
      COUNTING: begin
        if (count_reg == COUNT_MAX) begin
          state_next = OVERFLOW;
          count_next = count_reg;
        end else begin
          state_next = COUNTING;
          count_next = count_reg + 1;
        end
      end
      OVERFLOW: begin
        if (stopnclear) begin
          state_next = IDLE;
          count_next = 4'b0000;
        end else begin
          state_next = OVERFLOW;
          count_next = count_reg;
        end
      end
      default: begin
        error = 1;
        state_next = IDLE;
        count_next = 4'b0000;
      end
    endcase
  end

  // State and count registers
  always @(posedge clk, negedge rst_l) begin
    if (~rst_l) begin
      state_reg <= IDLE;
      count_reg <= 4'b0000;
      busy <= 0;
      error <= 0;
    end else begin
      state_reg <= state_next;
      count_reg <= count_next;
      busy <= (state_reg == COUNTING);
    end
  end

  // Error checking
  always @(state_reg, start, stopnclear) begin
    if (state_reg == OVERFLOW && start) begin
      error <= 1;
    end else begin
      error <= 0;
    end
  end

endmodule