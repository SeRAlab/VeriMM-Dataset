module top_module(
   
   data_out,
   
   datamode, data_in
   );input  [1:0]    datamode;
   input  [63:0]   data_in;
   output [63:0]   data_out;

   wire [3:0] data_size;
      
   assign data_size[0]= (datamode[1:0]==2'b00);
   assign data_size[1]= (datamode[1:0]==2'b01);
   assign data_size[2]= (datamode[1:0]==2'b10);
   assign data_size[3]= (datamode[1:0]==2'b11);

   
   assign data_out[7:0]   = data_in[7:0];

   
   assign data_out[15:8]  = {(8){data_size[0]}}      & data_in[7:0]   |
                            {(8){(|data_size[3:1])}} & data_in[15:8] ;
   
   
   assign data_out[23:16] = {(8){(|data_size[1:0])}} & data_in[7:0]   |
                            {(8){(|data_size[3:2])}} & data_in[23:16] ; 

   
   assign data_out[31:24] = {(8){data_size[0]}}      & data_in[7:0]   |
                            {(8){data_size[1]}}      & data_in[15:8]  |
                            {(8){(|data_size[3:2])}} & data_in[31:24] ; 
   
   
   assign data_out[39:32] = {(8){(|data_size[2:0])}} & data_in[7:0]   |
                            {(8){data_size[3]}}      & data_in[39:32] ;

   
   assign data_out[47:40] = {(8){data_size[0]}}      & data_in[7:0]   |
                            {(8){(|data_size[2:1])}} & data_in[15:8]  |
                            {(8){data_size[3]}}      & data_in[47:40] ;

   
   assign data_out[55:48] = {(8){(|data_size[1:0])}} & data_in[7:0]   |
                            {(8){data_size[2]}}      & data_in[23:16] |
                            {(8){data_size[3]}}      & data_in[55:48] ;
   
   
   assign data_out[63:56] = {(8){data_size[0]}}      & data_in[7:0]   |
                            {(8){data_size[1]}}      & data_in[15:8]  |
                            {(8){data_size[2]}}      & data_in[31:24] |
                            {(8){data_size[3]}}      & data_in[63:56] ;

endmodule