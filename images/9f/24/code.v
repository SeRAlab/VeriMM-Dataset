module top_module(DATA, CLOCK, CLEAR, PRESET, SLAVE_CLOCK, OUT);input DATA;
   input CLOCK;
   input CLEAR;
   input PRESET;
   input SLAVE_CLOCK;
   output OUT;
   reg    OUT;

   
   always @(posedge CLOCK or posedge PRESET or posedge CLEAR)
   if (CLEAR)
     OUT <= 1'b0;
   else
     if (PRESET)
       OUT <= 1'b1;
     else
       OUT <= DATA;
endmodule