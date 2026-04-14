module top_module(
  input clock,
  input resetn,
  input enable,

  input shift,
  input incr_cntl,
  input [63:0] shift_in,
  input [31:0] incr_val,
  output reg [31:0] data_out,
  output reg [63:0] shift_out
);parameter COUNTER_WIDTH=64;
parameter INCREMENT_WIDTH=32;
parameter DAISY_WIDTH=64;

reg [COUNTER_WIDTH-1:0] counter;

always@(posedge clock or negedge resetn)
begin
  if(!resetn)
    counter <= {COUNTER_WIDTH{1'b0}};
  else if(shift)
    counter <= {shift_in, counter[DAISY_WIDTH-1:0]};
  else if(enable && incr_cntl)
    counter <= counter + {incr_val, 32'b0};
end

assign data_out = counter[31:0];
assign shift_out = {counter, shift_in} >> COUNTER_WIDTH;

endmodule