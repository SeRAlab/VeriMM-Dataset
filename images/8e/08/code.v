module top_module(
  input [(16 - 1):0] input_port,
  output signed [(16 - 1):0] output_port,
  input clk,
  input ce,
  input clr);reg signed [(16 - 1):0] output_port_reg;
  wire signed [(16 - 1):0] input_port_1_40;
  assign input_port_1_40 = input_port;
  
  always @(posedge clk) begin
    if (clr) begin
      output_port_reg <= 0;
    end
    else if (ce) begin
      output_port_reg <= input_port_1_40;
    end
  end
  
  assign output_port = output_port_reg;
endmodule