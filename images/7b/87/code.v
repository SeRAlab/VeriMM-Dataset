module top_module(D0, D1, D2, D3, S0, S1, Y);input D0, D1, D2, D3, S0, S1;
   output Y;
   
   wire notS0, notS1;
   wire notS0andnotS1, S0andnotS1, notS0andS1, S0andS1; // Declare S0andS1 to resolve the compilation error
   
   // inverting select signals
   assign notS0 = ~S0;
   assign notS1 = ~S1;
   
   // creating intermediate signals for output
   assign notS0andS1 = notS0 & notS1; // Corrected to form the right intermediate signal
   assign S0andnotS1 = S0 & notS1;
   assign notS0andS1 = notS0 & S1; // Ensure correct naming for clarity
   assign S0andS1 = S0 & S1; // Add this missing intermediate signal

   // multiplexer output
   assign Y = D0 & notS0andnotS1 |
              D1 & S0andnotS1 |
              D2 & notS0andS1 |
              D3 & S0andS1;
endmodule