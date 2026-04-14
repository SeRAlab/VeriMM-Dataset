module top_module(CLK,RST_N,update_x,update_y,EN_update,update,RDY_update);parameter [15 : 0] m_val = 16'b0; 
  input CLK; 
  input RST_N; 
  input [15 : 0] update_x; 
  input [15 : 0] update_y; 
  input EN_update; 
  output [15 : 0] update; 
  output RDY_update; 
  wire [15 : 0] update; 
  wire RDY_update; 
  wire [31 : 0] update_x_PLUS_update_y_MUL_m_val___d2; 
  assign update = update_x_PLUS_update_y_MUL_m_val___d2[15:0] ; 
  assign RDY_update = 1'd1 ; 
  assign update_x_PLUS_update_y_MUL_m_val___d2 = 
  (update_x + update_y) * m_val ; 
 endmodule