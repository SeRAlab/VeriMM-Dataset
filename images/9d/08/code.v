module top_module(
  input switch_input,
  input clk, // Added the clock input
  output debounced_output
);parameter DELAY_TIME = 10; // delay time in clock cycles
  
  reg [DELAY_TIME-1:0] shift_reg; // shift register for delay element
  reg state; // state machine state
  reg debounced_state; // debounced state of switch
  
  always @(posedge clk) begin
    // shift register
    shift_reg <= {shift_reg[DELAY_TIME-2:0], switch_input};
    
    // state machine
    case(state)
      1'b0: // released state
        if (shift_reg == {DELAY_TIME{1'b0}}) begin
          debounced_state <= 1'b0;
          state <= 1'b1;
        end
      1'b1: // pressed state
        if (shift_reg == {DELAY_TIME{1'b1}}) begin
          debounced_state <= 1'b1;
          state <= 1'b0;
        end
    endcase
  end
  
  assign debounced_output = debounced_state;
  
endmodule