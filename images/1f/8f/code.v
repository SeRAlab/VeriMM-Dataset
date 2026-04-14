module pipeline_adder(clk, reset, input_a, input_b, output_sum, valid);  
  input clk;  
  input reset;  
  input [7:0] input_a;  
  input [7:0] input_b;  
  output reg [7:0] output_sum;  
  output reg valid;  

  reg [7:0] a_reg, b_reg;  
  reg [7:0] sum_reg;  

  always @(posedge clk or posedge reset) begin  
    if (reset) begin  
      a_reg <= 0;  
      b_reg <= 0;  
      sum_reg <= 0;  
      output_sum <= 0;  
      valid <= 0;  
    end else begin  
      // IF Stage  
      a_reg <= input_a;  
      b_reg <= input_b;  
      
      // ID Stage  
      // No operation on ID for this simple example

      // EX Stage  
      sum_reg <= a_reg + b_reg;  

      // MEM Stage  
      // No operation on MEM for this simple example

      // WB Stage  
      output_sum <= sum_reg;  
      valid <= 1;  
    end  
  end  
endmodule