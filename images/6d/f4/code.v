module top_module(
   
   packet_out,
   
   access_in, write_in, datamode_in, ctrlmode_in, dstaddr_in, data_in,
   srcaddr_in
   );parameter AW=32;
   parameter DW=32;
   parameter PW=104;
   
   
   input 	    access_in;
   input 	    write_in;   
   input [1:0] 	    datamode_in;
   input [3:0] 	    ctrlmode_in;
   input [AW-1:0]   dstaddr_in;
   input [DW-1:0]   data_in;   
   input [AW-1:0]   srcaddr_in;   
   
   
   output [PW-1:0]  packet_out;

   assign packet_out[0]       = access_in;
   assign packet_out[1]       = write_in;
   assign packet_out[3:2]     = datamode_in[1:0];
   assign packet_out[7:4]     = ctrlmode_in[3:0];
   assign packet_out[39:8]    = dstaddr_in[AW-1:0];
   assign packet_out[71:40]   = data_in[AW-1:0];
   assign packet_out[103:72]  = srcaddr_in[AW-1:0];
     
endmodule