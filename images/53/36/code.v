module top_module(
  // inputs:
  address,
  clk,
  in_port,
  reset_n,

  // outputs:
  readdata
);output  [ 31: 0] readdata;
  input   [  1: 0] address;
  input            clk;
  input   [  7: 0] in_port;
  input            reset_n;

  wire             clk_en;
  wire    [  7: 0] data_in;
  wire    [  7: 0] read_mux_out;
  reg     [ 31: 0] readdata;
  
  // create a wire that is high when the clock is enabled
  assign clk_en = 1;
  
  // create a wire that connects to the input data
  assign data_in = in_port;
  
  // create a multiplexer that selects the data input if the address is 0, and otherwise selects 0
  assign read_mux_out = {8 {(address == 0)}} & data_in;
  
  // create a register that is updated on the positive edge of the clock when clk_en is high
  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 0) begin
      readdata <= 0;
    end else if (clk_en) begin
      readdata <= {32'b0, read_mux_out};
    end
  end
  
endmodule