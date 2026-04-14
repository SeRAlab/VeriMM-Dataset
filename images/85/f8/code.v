module top_module(
                    
                     address,
                     chipselect,
                     clk,
                     in_port,
                     reset_n,
                     write_n,
                     writedata,

                    
                     out_port,
                     readdata
                  )
;output  [ 15: 0] out_port;
  output  [ 15: 0] readdata;
  input   [  1: 0] address;
  input            chipselect;
  input            clk;
  input   [ 15: 0] in_port;
  input            reset_n;
  input            write_n;
  input   [ 15: 0] writedata;

  wire             clk_en;
  wire    [ 15: 0] data_in;
  reg     [ 15: 0] data_out;
  wire    [ 15: 0] out_port;
  wire    [ 15: 0] read_mux_out;
  reg     [ 15: 0] readdata;
  assign clk_en = 1;
  
  assign read_mux_out = {16 {(address == 0)}} & data_in;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          readdata <= 0;
      else if (clk_en)
          readdata <= read_mux_out;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else if (chipselect && ~write_n && (address == 0))
          data_out <= writedata[15 : 0];
    end


  assign out_port = data_out;
  assign data_in = in_port;

endmodule