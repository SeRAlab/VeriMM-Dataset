module top_module(O1,
    O2,
    O3,
    I1,
    I2,
    p_18_out,
    I3,
    E,
    clk,
    Q);output O1;
  output O2;
  output reg [5:0] O3; // Change to reg as it will be assigned in an always block
  
  input [5:0] I1;
  input I2;
  input p_18_out;
  input [0:0] I3;
  input [0:0] E;
  input clk;
  input [0:0] Q;

  reg [5:0] buffer [0:5]; // Change wire to reg
  reg [2:0] pointer;
  reg [2:0] counter;

  assign O1 = (pointer == counter) ? 1 : 0;
  assign O2 = ((pointer+1) == counter) ? 1 : 0;

  always @(posedge clk) begin
    if (E) begin
      buffer[pointer] <= I1; // This is now valid as buffer is declared as reg
      pointer <= (pointer == 5) ? 0 : pointer + 1;
    end
    if (Q) begin
      O3 <= buffer[counter]; // This is now valid as O3 is declared as reg
      counter <= (counter == 5) ? 0 : counter + 1;
    end
  end

endmodule