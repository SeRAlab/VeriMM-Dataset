module top_module(
  (* LOC="13" *)
  output pin1,
  (* LOC="21" *)
  input clk
);reg [23:0] led_timer;

  always @(posedge clk) begin
    led_timer <= led_timer + 1;
  end

  
  assign pin1 = led_timer[23];
endmodule