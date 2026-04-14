module top_module(mem_write_disable_buf,sehold_buf,se_buf,arst_l_buf,mem_write_disable,sehold,se,arst_l);output mem_write_disable_buf; 
 output sehold_buf; 
 output se_buf; 
 output arst_l_buf; 
 input mem_write_disable; 
 input sehold; 
 input se; 
 input arst_l; 
 assign mem_write_disable_buf = mem_write_disable; 
 assign sehold_buf = sehold; 
 assign se_buf = se; 
 assign arst_l_buf = arst_l; 
 endmodule