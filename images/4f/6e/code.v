module top_module(
                      // inputs:
                       address,
                       chipselect,
                       clk,
                       reset_n,
                       write_n,
                       writedata,

                      // outputs:
                       out_port,
                       readdata
                    )
;output [7:0]      out_port;
  output [7:0]      readdata;
  input   [1:0]     address;
  input             chipselect;
  input             clk;
  input             reset_n;
  input             write_n;
  input   [7:0]     writedata;

  reg    [7:0]      data_out;
  wire   [7:0]      read_mux_out;
  wire              clk_en;
  
  assign clk_en = 1;
  
  //s1, which is an e_avalon_slave
  assign read_mux_out = {1 {(address == 0)}} & data_out;

  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 0) begin
      data_out <= 0;
    end
    else if (chipselect && ~write_n && (address == 0)) begin
      data_out <= writedata;
    end
  end

  assign readdata = read_mux_out;
  assign out_port = data_out;

endmodule