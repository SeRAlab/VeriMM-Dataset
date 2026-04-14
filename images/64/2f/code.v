module top_module(m_out, A, B, select);output	m_out;
  input 		A, B;
  input		select;
   
  assign m_out = (select)? A : B;
 endmodule