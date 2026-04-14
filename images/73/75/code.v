module top_module(
  input [63:0]pc_in,
  input [63:0]imm_data_in,
  input [63:0]read_data1_in,
  input [63:0]read_data2_in,
  input [4:0]rs1_in,
  input [4:0]rs2_in,
  input [4:0]rd_in,
  input [3:0]funct4_in,
  input [1:0]wb_in,
  input [2:0]m_in,
  input [2:0]ex_in,
  
  input clk,
  
  output reg [63:0]pc_out,
  output reg [63:0]imm_data_out,
  output reg [63:0]read_data1_out,
  output reg [63:0]read_data2_out,
  output reg [4:0]rs1_out,
  output reg [4:0]rs2_out,
  output reg [4:0]rd_out,
  output reg [3:0]funct4_out,
  output reg  [1:0]wb_out,
  output reg  [2:0]m_out,
  output reg  [2:0]ex_out
);always @ (posedge clk)
begin
  pc_out = pc_in;
  imm_data_out = imm_data_in;
  read_data1_out = read_data1_in;
  read_data2_out = read_data2_in;
  rs1_out = rs1_in;
  rs2_out = rs2_in;
  rd_out = rd_in;
  funct4_out = funct4_in;
  wb_out = wb_in;
  m_out = m_in;
  ex_out = ex_in;
end

endmodule