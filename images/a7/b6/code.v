module top_module(
   
   access_out, write_out, datamode_out, ctrlmode_out, dstaddr_out,
   data_out, srcaddr_out,
   
   packet_in
   );parameter AW=32;
   parameter DW=32;
   parameter PW=104;
   
   
   output 	    access_out;
   output 	    write_out;   
   output [1:0]     datamode_out;
   output [3:0]     ctrlmode_out;   
   output [AW-1:0]  dstaddr_out;
   output [DW-1:0]  data_out;   
   output [AW-1:0]  srcaddr_out;   
   
   
   input [PW-1:0]   packet_in;

   assign access_out          = packet_in[0];
   assign write_out           = packet_in[1];
   assign datamode_out[1:0]   = packet_in[3:2];
   assign ctrlmode_out[3:0]   = packet_in[7:4];
   assign dstaddr_out[AW-1:0] = packet_in[39:8];
   assign data_out[AW-1:0]    = packet_in[71:40];
   assign srcaddr_out[AW-1:0] = packet_in[103:72];
     
endmodule