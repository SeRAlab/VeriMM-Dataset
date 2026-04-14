module top_module(clock, resetn, i_start, i_size,o_dataout, o_dataout_valid, i_dataout_stall, i_counter_reset);parameter DATA_WIDTH = 32; 
  input clock, resetn; 
  input i_start; 
  input [DATA_WIDTH-1:0] i_size; 
  output [DATA_WIDTH-1:0] o_dataout; 
  output o_dataout_valid; 
  input i_dataout_stall; 
  input i_counter_reset; 
  reg [DATA_WIDTH-1:0] counter; 
  always @(posedge clock or negedge resetn) 
  begin 
  if (~resetn) 
  begin 
  counter <= 32'h00000000; 
  end 
  else 
  begin 
  if (i_counter_reset) 
  begin 
  counter <= {DATA_WIDTH{1'b0}}; 
  end 
  else if (i_start && ~i_dataout_stall && counter < i_size) 
  begin 
  counter <= counter + 1; 
  end 
  end 
  end 
  assign o_dataout = counter; 
  assign o_dataout_valid = i_start && !i_counter_reset && (counter < i_size); 
 endmodule