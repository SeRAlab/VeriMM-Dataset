module top_module(
  input [4:0]rd_in,
  input [63:0]alu_in,
  input [63:0]read_data_in,
  input [1:0]wb_in,

  input clk,
  
  output reg [4:0]rd_out,
  output reg  [63:0]alu_out,
  output reg  [63:0]read_data_out,
  output reg  [1:0]wb_out
);always@(posedge clk)
begin
  rd_out = rd_in;
  alu_out = alu_in;
  read_data_out = read_data_in;
  wb_out = wb_in;
end

endmodule