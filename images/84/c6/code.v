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
  
  // Implement clock enable signal
  assign clk_en = 1;
  
  // Implement input data signal
  assign data_in = in_port;
  
  // Implement read_mux_out signal
  assign read_mux_out = (address == 2'b00) ? data_in : 32'b0;
  
  // Implement readdata register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          readdata <= 0;
      else if (clk_en)
          readdata <= read_mux_out;
    end

endmodule