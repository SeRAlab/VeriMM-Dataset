module top_module(
  input [1:0] address,
  input clk,
  input in_port,
  input reset_n,
  output reg [31:0] readdata
);wire clk_en;
  wire data_in;
  wire read_mux_out;

  assign clk_en = 1;

  //s1, which is an e_avalon_slave
  assign read_mux_out = {1 {(address == 0)}} & data_in;

  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 0) begin
      readdata <= 0;
    end
    else if (clk_en) begin
      readdata <= {32'b0 | read_mux_out};
    end
  end

  assign data_in = in_port;

endmodule