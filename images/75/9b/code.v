module top_module(
  input clk,
  input button,
  output reg debounced_button
);parameter IDLE = 2'b00, PRE_DEBOUNCE = 2'b01, DEBOUNCE = 2'b10;
reg [1:0] state, next_state;
reg [9:0] debounce_counter;

always @(posedge clk) begin
  state <= next_state;
  case(state)
    IDLE: begin
      if(button) next_state <= PRE_DEBOUNCE;
      else next_state <= IDLE;
    end
    PRE_DEBOUNCE: begin
      if(button) next_state <= PRE_DEBOUNCE;
      else begin
        next_state <= DEBOUNCE;
        debounce_counter <= 0;
      end
    end
    DEBOUNCE: begin
      if(button && debounce_counter < 9) begin
        debounce_counter <= debounce_counter + 1;
        next_state <= DEBOUNCE;
      end
      else begin
        debounced_button <= button;
        next_state <= IDLE;
      end
    end
  endcase
end

endmodule