module top_module(
  input clk,
  input reset,
  input enable,
  input button,
  output reg [2:0] counter_out,
  output reg [2:0] led_out
);reg [2:0] counter_reg;
reg button_pressed;
wire button_released;

assign button_released = ~button_pressed;

always @(posedge clk) begin
  if (reset) begin
    counter_reg <= 3'b000;
  end else if (enable) begin
    if (button_released) begin
      counter_reg <= counter_reg + 1;
    end else begin
      button_pressed <= 1'b1;
    end
  end else begin
    counter_reg <= counter_reg;
  end
end

always @(counter_reg) begin
  led_out <= counter_reg;
end

assign counter_out = counter_reg;

endmodule