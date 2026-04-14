module top_module(clk,
                  left, right,
                  exp);input clk;
  input[5:0] left, right;

  output[2:0] exp;
  reg[2:0] exp;


  

  wire signed[2:0] expl = left[5:3] - 3;
  wire signed[2:0] expr = right[5:3] - 3;

  
  reg signed[3:0] sumExp;


  always @ (posedge clk) begin




    sumExp <= (expl + expr) < -2      

            ? -3
            : expl + expr;

    exp[2:0] <= sumExp + 3;
  end
endmodule