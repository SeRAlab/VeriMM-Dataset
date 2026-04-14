module top_module(data_out, data_in, load, clk);input [15:0] data_in;
   output load, clk;
   output reg [15:0] data_out;

  always @ (posedge clk)
    if (load) data_out <= data_in;endmodule