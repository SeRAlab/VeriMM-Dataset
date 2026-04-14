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
  input            in_port;
  input            reset_n;


  wire             clk_en;
  wire             data_in;
  wire             read_mux_out;
  reg     [ 31: 0] readdata;
  
  // Clock enable signal
  assign clk_en = 1;
  
  // Read multiplexer output
  assign read_mux_out = {1 {(address == 0)}} & data_in;
  
  // Read data output
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          readdata <= 0;
      else if (clk_en)
          readdata <= {32'b0 | read_mux_out};
    end

  // Data input
  assign data_in = in_port;

endmodule