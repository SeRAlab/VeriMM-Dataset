module top_module(input i_clk, input i_rst, output o_led_r, output o_led_g, output o_led_b);parameter r_bit_r=25; 
  parameter r_bit_g=24; 
  parameter r_bit_b=23; 

  
  parameter p_bit_count = 25;
  
  parameter p_bit_d     = 16;

  reg [p_bit_count:0] r_count;
  
  
  
  assign o_led_r = r_count[r_bit_r] || r_count[p_bit_d] || r_count[p_bit_d-1] || r_count[p_bit_d-2] || r_count[p_bit_d-3];
  
  assign o_led_g = r_count[r_bit_g] || r_count[p_bit_d] || r_count[p_bit_d-1] || r_count[p_bit_d-2] || r_count[p_bit_d-3];
  
  assign o_led_b = r_count[r_bit_b] || r_count[p_bit_d] || r_count[p_bit_d-1] || r_count[p_bit_d-2] || r_count[p_bit_d-3];

  
  always @(posedge i_clk)
  begin
    if(i_rst) begin
      
      r_count = 0;
    end else begin
      
      r_count <= r_count + 1;
    end
  end

endmodule