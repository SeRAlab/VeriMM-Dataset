module top_module(
  clock,
  resetn,
  enable,

  shift,
  incr_cntl,
  shift_in,
  incr_val,
  data_out,
  shift_out
);parameter COUNTER_WIDTH=64;
parameter INCREMENT_WIDTH=32;

input clock;
input resetn;
input enable;

input shift;
input incr_cntl;
input shift_in;
input [INCREMENT_WIDTH-1:0] incr_val;

output [31:0] data_out;
output shift_out;

reg [COUNTER_WIDTH-1:0] counter;

always@(posedge clock or negedge resetn)
begin
  if( !resetn )
    counter <= { COUNTER_WIDTH{1'b0} };
  else if(shift) 
    counter <= { counter[COUNTER_WIDTH-2:0], shift_in };
  else if(enable && incr_cntl) 
    counter <= counter + incr_val;
end

assign data_out = counter;
assign shift_out = counter[COUNTER_WIDTH-1:COUNTER_WIDTH-1];

endmodule