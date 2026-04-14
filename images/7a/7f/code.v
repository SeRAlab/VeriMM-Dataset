module top_module(
  input clk,
  input reset,
  input [15:0] input_vector,
  output reg [15:0] output_vector
);integer i;
  
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      output_vector <= 16'b0;
    end else begin
      for (i = 0; i < 16; i = i + 2) begin
        output_vector[i] <= input_vector[i+1];
        output_vector[i+1] <= input_vector[i];
      end
    end
  end
  
endmodule