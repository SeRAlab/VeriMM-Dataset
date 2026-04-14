module top_module(
                        // inputs:
                         address,
                         clk,
                         in_port,
                         reset_n,

                        // outputs:
                         readdata
                      )
;output  [ 31: 0] readdata;
  input   [  1: 0] address;
  input            clk;
  input   [ 19: 0] in_port;
  input            reset_n;

  wire             clk_en;
  wire    [ 19: 0] data_in;
  wire    [ 19: 0] read_mux_out;
  reg     [ 31: 0] readdata;
  assign clk_en = 1;
  //s1, which is an e_avalon_slave
  assign read_mux_out = {20 {(address == 2'b00)}} & data_in | {12'b0, in_port[19:0]} & {20 {(address == 2'b01)}};
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          readdata <= 0;
      else if (clk_en)
          readdata <= {32'b0 | read_mux_out};
    end


  assign data_in = in_port;

endmodule