module top_module(Clk, Rst, ld, sh_en, data_in, ser_in, ser_out );input Clk, Rst; 
     input ld, sh_en, ser_in; 
     input [10:0] data_in ; 
     output ser_out; 
     
     reg [10:0] transmit_data;
     

     assign ser_out = transmit_data[0]; 
     
     
     always @(posedge Clk, negedge Rst)
          if(!Rst)  transmit_data <= 10'b0;   else
          if(ld)    transmit_data <= data_in; else 
          if(sh_en) transmit_data <= { ser_in, transmit_data[10:1] } ; 
     
endmodule