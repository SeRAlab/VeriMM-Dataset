module top_module(
               
                address,
                clock,
                reset_n,

               
                readdata
             )
;output  [ 31: 0] readdata;
  input            address;
  input            clock;
  input            reset_n;

  wire    [ 31: 0] readdata;
  
  assign readdata = address ? 1502149608 : 0;

endmodule