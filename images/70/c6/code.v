module top_module(
  input [7:0] x,
  output [7:0] y
);reg [7:0] y_n; // current estimate of square root
  reg [7:0] y_n1; // next estimate of square root
  reg [7:0] x_int; // integer representation of input
  reg done; // flag to indicate when calculation is complete
  
  // convert binary input to integer
  assign x_int = $unsigned(x);
  
  // initialize y(0) to 128
  initial y_n = 128;
  
  always @(*) begin
    // calculate y(n+1) using Newton-Raphson method
    y_n1 = (y_n + x_int/y_n)/2;
    
    // check if y(n+1) and y(n) are within 1 of each other
    if (y_n1 >= y_n-1 && y_n1 <= y_n+1) begin
      done = 1; // calculation is complete
    end else begin
      y_n = y_n1; // update current estimate
      done = 0; // calculation is not yet complete
    end
  end
  
  // convert final estimate of square root back to binary and output it
  assign y = $unsigned(y_n1);
  
endmodule