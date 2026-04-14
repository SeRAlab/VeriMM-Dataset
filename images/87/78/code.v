module top_module(in_3, in_2, in_1, in_0, out);// Truth table parameter represents the default function of the LUT.
   // The most significant bit is the output when all inputs are logic one.
   parameter Truth_table = 16'b0000000000000000; 
   
   input in_0, in_1, in_2, in_3;
   output reg out;
   integer selected_row;
   wire [3:0] a;

   // Assuming "interconnect" is a simple wiring or buffer, 
   // we can remove it or replace it with direct assignments.
   assign a[0] = in_0;
   assign a[1] = in_1;
   assign a[2] = in_2;
   assign a[3] = in_3;

   always @* begin
      selected_row = {a[3], a[2], a[1], a[0]};
      out = Truth_table[selected_row];
   end
     
endmodule