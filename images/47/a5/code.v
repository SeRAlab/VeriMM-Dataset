module top_module(I0, I1, I2, I3, S0, S1, Y);input I0, I1, I2, I3, S0, S1;
   output Y;
   
   wire notS0, notS1;
   
   // Fixed NOT Gate implementation
   assign notS0 = ~S0;
   assign notS1 = ~S1;
   
   wire and0, and1, and2, and3;
   
   // Fixed AND Gate implementation
   assign and0 = I0 & notS1 & notS0;
   assign and1 = I1 & S1 & notS0;
   assign and2 = I2 & notS1 & S0;
   assign and3 = I3 & S1 & S0;

   // Final output Y using OR operations
   assign Y = and0 | and1 | and2 | and3;

   // End of module
endmodule