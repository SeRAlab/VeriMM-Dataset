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
  
  assign readdata = address ? 1500364641 : 255;

endmodule