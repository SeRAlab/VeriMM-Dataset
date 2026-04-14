module top_module(i_clk, i_rst, mm_adr, mm_we, mm_idat, mm_odat);input i_clk; 
  input i_rst; 
  input [11:0] mm_adr; 
  input mm_we; 
  output reg [23:0] mm_idat; 
  input [23:0] mm_odat; 
  reg [24:0] m_memory [4095:0]; 
  integer i; 
  always @(posedge i_clk) begin 
  if(i_rst) begin 
  mm_idat <= 0; 
  for(i = 0; i < 4095; i = i + 1) 
  m_memory[i] = 0; 
  m_memory[64] = {9'b011010000, 3'b010, 12'b000000000010}; 
  m_memory[65] = {9'o400, 15'h0}; 
  m_memory[66] = {12'b0, 12'b100000000000}; 
  end 
  else begin 
  if(mm_we) 
  m_memory[mm_adr] <= mm_odat; 
  else 
  mm_idat <= m_memory[mm_adr]; 
  end 
  end 
 endmodule