module top_module(input sqwv,input fsk_out_trigger,input fsk_out,input manual,output reg [44:0] decoded,output reg done);reg prev_trig; 
  integer bits_rcvd; 
  integer bits_left; 
  reg odd_bit, even_bit; 
  initial begin 
  bits_rcvd = 0; 
  bits_left = 44; 
  decoded = 0; 
  done = 0; 
  end 
  always @(posedge sqwv) begin 
  if (manual == 1) begin 
  bits_rcvd <= 0; 
  bits_left <= 44; 
  decoded <= 0; 
  done <= 0; 
  end 
  else if (fsk_out_trigger != prev_trig) begin 
  if (bits_left >= 0) begin 
  if (bits_rcvd % 2 == 0) begin 
  even_bit <= fsk_out; 
  end 
  else begin 
  decoded[bits_left] <= even_bit; 
  bits_left <= bits_left - 1; 
  end 
  bits_rcvd <= bits_rcvd + 1; 
  end 
  else done <= 1; 
  prev_trig <= fsk_out_trigger; 
  end 
  end 
 endmodule