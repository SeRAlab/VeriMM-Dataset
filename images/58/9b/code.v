module top_module(y,carryout,isValid,currentsum,currentcarryout,currentbitcount,clk,rst,a,b,carryin);output reg [3:0]y;
  output reg carryout;
  output reg isValid; 
  output reg currentsum, currentcarryout;
  output reg [1:0]currentbitcount;
  input clk,rst;
  input a,b,carryin;

  wire intermediatecarry;
  
  // intermediatecarry should point to the carryin only for the 1st bit afterward it is previous bit's carryout
  assign intermediatecarry = ( currentbitcount == 3'd0) ? carryin : currentcarryout;
  
  // Full adder to work on the posedge of the clock
  always@(posedge clk)
  begin
    currentsum <= a ^ b ^ intermediatecarry;
    currentcarryout <= ( a & b ) | ( a & intermediatecarry ) | ( b & intermediatecarry );
  end

  // Shift register for serial addition
  always@(posedge clk)
  begin
    if(rst)
      begin
        y <= 0;
        carryout <= 0;
      end
    else
      begin
        y <= {currentsum, y[3:1]};
        carryout <= ( currentbitcount == 3'd4 ) ? currentcarryout : 0;
      end
    end

  // Bit counter to keep track of number of bits added
  always@(posedge clk)
  begin
    if(rst)
        currentbitcount <= 0;
    else
        currentbitcount <= currentbitcount + 1;
  end

  // isValid will provide the indication as to whether the addition is completed  
  always@(posedge clk)
  begin
    if(rst)
        isValid <= 0;
    else
        isValid <= (currentbitcount == 3) ? 1 : 0;
  end
  
endmodule