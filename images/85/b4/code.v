module top_module(
                     // inputs:
                      address,
                      clk,
                      in_port,
                      reset_n,

                     // outputs:
                      readdata
                   )
;output  [ 15: 0] readdata;
  input   [  1: 0] address;
  input            clk;
  input   [ 15: 0] in_port;
  input            reset_n;

  wire             clk_en;
  wire    [ 15: 0] data_in;
  wire    [ 15: 0] read_mux_out;
  reg     [ 15: 0] readdata;
  assign clk_en = 1;
  //s1, which is an e_avalon_slave
  assign read_mux_out = {16 {(address == 0)}} & data_in;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          readdata <= 0;
      else if (clk_en)
          readdata <= read_mux_out;
    end


  assign data_in = in_port;

endmodule