module top_module(
  input div_clock,
  input reset,
  output enable_cuenta,
  output write_enable,
  output write_value_reg_en,
  output read_value_reg_en,
  output led_write,
  output led_read,
  output [3:0] estado
);// Define the states of the FSM
  parameter STATE_0 = 0;
  parameter STATE_1 = 1;
  parameter STATE_2 = 2;
  parameter STATE_3 = 3;
  parameter STATE_4 = 4;

  // Define the current state of the FSM
  reg [3:0] state;

  // Set the initial state of the FSM
  initial begin
    state <= -1;
  end

  // Advance the FSM on the rising edge of div_clock or reset
  always @(posedge div_clock or posedge reset) begin
    if (reset) begin
      state <= -1;
    end else begin
      case (state)
        STATE_0: begin
          state <= STATE_1;
        end
        STATE_1: begin
          state <= STATE_2;
        end
        STATE_2: begin
          state <= STATE_3;
        end
        STATE_3: begin
          state <= STATE_4;
        end
        STATE_4: begin
          state <= STATE_0;
        end
        default: begin
          state <= STATE_0;
        end
      endcase
    end
  end

  // Define the outputs of the FSM
  assign estado = state;
  assign enable_cuenta = (state == STATE_4);
  assign write_enable = ~(state == STATE_1);
  assign write_value_reg_en = (state == STATE_1);
  assign read_value_reg_en = (state == STATE_3);
  assign led_write = (state == STATE_0) || (state == STATE_1) || (state == STATE_2);
  assign led_read = (state == STATE_3) || (state == STATE_4);

endmodule