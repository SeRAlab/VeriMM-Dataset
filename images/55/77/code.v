module top_module(y,carryout,isValid,currentsum,currentcarryout,currentbitcount,clk,rst,a,b,carryin);output reg [3:0]y;
  output reg carryout;
  output reg isValid; 
  output reg currentsum, currentcarryout;
  output reg [1:0]currentbitcount;
  input clk,rst;
  input a,b,carryin;

  wire intermediatecarry;
  
  
  assign intermediatecarry = ( currentbitcount == 3'd0) ? carryin : currentcarryout;
  
  
  
  always@(posedge clk)
  begin
    currentsum <= a ^ b ^ intermediatecarry;
    currentcarryout <= ( a & b ) | ( a & intermediatecarry ) | ( b & intermediatecarry );
  end

  
  
  

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
        carryout <= currentcarryout;
      end
    end

  
  
  always@(posedge clk)
  begin
    if(rst)
        currentbitcount <= 0;
    else
        currentbitcount <= currentbitcount + 1; 
  end

  
  
  always@(posedge clk)
  begin
    if(rst)
        isValid <= 0;
    else
        isValid <= (currentbitcount == 3) ? 1 : 0; 
  end
  
endmodule