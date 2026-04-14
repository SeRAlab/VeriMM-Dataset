module top_module(
   input bit_one,
   input bit_two,
   input carry_in,
   output result,
   output carry_out
   );wire   in_or;
  wire   carry_or;
  wire   in_and;
       
  assign in_or = bit_one ^ bit_two;
  assign carry_or = in_or & carry_in;
  assign in_and = bit_one & bit_two;
  assign result   = in_or ^ carry_in;
  assign carry_out = carry_or | in_and;endmodule