module top_module(led_clk ,led_rst_n ,led_in ,led_out);input led_clk ; 
  input led_rst_n ; 
  input [07:00] led_in ; 
  output [07:00] led_out ; 
  reg [09:00] led_cnt ; 
  wire led_clk ; 
  wire led_rst_n ; 
  wire [07:00] led_in ; 
  wire [07:00] led_out ; 
  always @(posedge led_clk or negedge led_rst_n) begin : SYS_LED_CTRL 
  if(!led_rst_n) 
  begin 
  led_cnt <= 'd0; 
  end 
  else 
  begin 
  led_cnt <= led_cnt + 1'b1; 
  end 
  end 
  assign led_out[00] = &led_in ; 
  assign led_out[01] = |led_in ; 
  assign led_out[02] = ~&led_in ; 
  assign led_out[03] = ~|led_in ; 
  assign led_out[04] = led_cnt[06] ; 
  assign led_out[05] = led_cnt[07] ; 
  assign led_out[06] = led_cnt[08] ; 
  assign led_out[07] = led_cnt[09] ; 
 endmodule