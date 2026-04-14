module top_module(
  input clock,
  input reset,
  output reg green_led,
  output reg yellow_led,
  output reg red_led
);parameter GREEN = 2'b00;
  parameter YELLOW = 2'b01;
  parameter RED = 2'b10;
  
  reg [1:0] state;
  
  always @(posedge clock) begin
    if (reset) begin
      state <= GREEN;
    end else begin
      case (state)
        GREEN: begin
          green_led <= 1'b1;
          yellow_led <= 1'b0;
          red_led <= 1'b0;
          state <= YELLOW;
        end
        YELLOW: begin
          green_led <= 1'b0;
          yellow_led <= 1'b1;
          red_led <= 1'b0;
          state <= RED;
        end
        RED: begin
          green_led <= 1'b0;
          yellow_led <= 1'b0;
          red_led <= 1'b1;
          state <= GREEN;
        end
      endcase
    end
  end

endmodule