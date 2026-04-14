module top_module(
   input      clk,      // clock
   input      reset_n,  // asynchronous reset 
   input  [3:0] input_binary, // 4-bit binary input
   output [3:0] output_ones_comp // 4-bit one's complement output
   );parameter CLK_FREQUENCY = 100000000;
  
  reg [3:0] temp_output;
  always @* begin
    temp_output = input_binary ^ 4'b1111;
  end
  
  reg [3:0] output_reg;
  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      output_reg <= 4'b0000;
    end
    else begin
      output_reg <= temp_output;
    end
  end
  
  assign output_ones_comp = output_reg;
  
endmodule