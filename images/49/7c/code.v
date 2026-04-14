module top_module(
  input [3:0] binary_in,
  input clk,
  input reset,
  output reg [2:0] ones_count
);reg [1:0] stage1_out;
  
  always @(posedge clk) begin
    if (reset) begin
      stage1_out <= 2'b0;
      ones_count <= 3'b0;
    end
    else begin
      stage1_out <= {binary_in[3:2]} & {binary_in[1:0]};
    end
  end
  
  always @(posedge clk) begin
    if (reset) begin
      ones_count <= 3'b0;
    end
    else begin
      ones_count <= {stage1_out[1], stage1_out[0], binary_in[0]} ^
                    {stage1_out[1], stage1_out[0], binary_in[1]} ^
                    {stage1_out[1], stage1_out[0], binary_in[2]} ^
                    {stage1_out[1], stage1_out[0], binary_in[3]};
    end
  end

endmodule