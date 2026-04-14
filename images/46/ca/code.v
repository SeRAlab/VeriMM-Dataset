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
;output           out_port;
  output           readdata;
  input   [  1: 0] address;
  input            chipselect;
  input            clk;
  input            reset_n;
  input            write_n;
  input            writedata;

  wire             clk_en;
  reg              data_out;
  wire             out_port;
  wire             read_mux_out;
  wire             readdata;
  
  // clock enable
  assign clk_en = 1;
  
  // read multiplexer
  assign read_mux_out = {1 {(address == 0)}} & data_out;
  
  // data_out register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else if (chipselect && ~write_n && (address == 0))
          data_out <= writedata;
    end
  
  // out_port output
  assign out_port = data_out;

  // readdata output
  assign readdata = read_mux_out;

endmodule