module top_module(
                   inv_af_rd_data,
                   af_empty_vec,
                   data_out
                   );parameter    FIFO_WIDTH = 1;       
   
   input [FIFO_WIDTH-1:0]  inv_af_rd_data; 

   input  [FIFO_WIDTH-1:0] af_empty_vec; 

   output [FIFO_WIDTH-1:0] data_out;     

   
   
   

   

`ifdef USE_VENDOR__NOR2_GATE

   
   

   
   
   

   a28_nor2_a2  DONT_TOUCH_a4_nor2_b1_inst [FIFO_WIDTH-1:0] 
     (.A        ( inv_af_rd_data ),
      .B        ( af_empty_vec   ),
      .Q        ( data_out       )
     );

`else

   
   assign data_out = ~(af_empty_vec | inv_af_rd_data);

`endif

   



endmodule