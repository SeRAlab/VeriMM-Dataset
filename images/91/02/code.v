module top_module(
  input [(16 - 1):0] input_port,
  output reg [(16 - 1):0] output_port,
  input clk,
  input ce,
  input clr
);always @(posedge clk) begin
    if (ce && !clr) begin
      output_port <= input_port;
    end
  end
  
  always @(posedge clk) begin
    if (!ce) begin
      output_port <= output_port;
    end
  end
  
  always @(posedge clk) begin
    if (clr) begin
      output_port <= 0;
    end
  end

endmodule