module top_module(
  input clk,
  input reset,
  output reg [3:0] out
);reg [3:0] pipeline_reg1;
  reg [3:0] pipeline_reg2;
  reg [3:0] pipeline_reg3;
  
  always @(posedge clk) begin
    if (reset) begin
      pipeline_reg1 <= 4'b0;
      pipeline_reg2 <= 4'b0;
      pipeline_reg3 <= 4'b0;
      out <= 4'b0;
    end else begin
      pipeline_reg1 <= out;
      pipeline_reg2 <= pipeline_reg1;
      pipeline_reg3 <= pipeline_reg2;
      out <= pipeline_reg3 + 1;
    end
  end

endmodule