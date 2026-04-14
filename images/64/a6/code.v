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
  input   [  9: 0] in_port;
  input            reset_n;

  wire             clk_en;
  wire    [  9: 0] data_in;
  wire    [  9: 0] read_mux_out;
  reg     [ 31: 0] readdata;
  
  // Select the data to be read from the input port
  assign read_mux_out = {10 {(address == 2'b00)}} & in_port;
  
  // Enable the clock signal
  assign clk_en = 1;
  
  // Assign the selected data to the data_in signal
  assign data_in = read_mux_out;
  
  // Update the readdata signal on the rising edge of the clock signal
  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 0) begin
      readdata <= 0;
    end else if (clk_en) begin
      readdata <= {32'b0 | data_in};
    end
  end

endmodule