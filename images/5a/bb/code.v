module top_module(
                     
                      address,
                      chipselect,
                      clk,
                      reset_n,
                      write_n,
                      writedata,

                     
                      bidir_port,
                      readdata
                   )
;inout   [  3: 0] bidir_port;
  output  [ 31: 0] readdata;
  input   [  1: 0] address;
  input            chipselect;
  input            clk;
  input            reset_n;
  input            write_n;
  input   [ 31: 0] writedata;

  wire    [  3: 0] bidir_port;
  wire             clk_en;
  reg     [  3: 0] data_dir;
  wire    [  3: 0] data_in;
  reg     [  3: 0] data_out;
  wire    [  3: 0] read_mux_out;
  reg     [ 31: 0] readdata;
  assign clk_en = 1;
  
  assign read_mux_out = ({4 {(address == 0)}} & data_in) |
    ({4 {(address == 1)}} & data_dir);

  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          readdata <= 0;
      else if (clk_en)
          readdata <= {32'b0 | read_mux_out};
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else if (chipselect && ~write_n && (address == 0))
          data_out <= writedata[3 : 0];
    end


  assign bidir_port[0] = data_dir[0] ? data_out[0] : 1'bZ;
  assign bidir_port[1] = data_dir[1] ? data_out[1] : 1'bZ;
  assign bidir_port[2] = data_dir[2] ? data_out[2] : 1'bZ;
  assign bidir_port[3] = data_dir[3] ? data_out[3] : 1'bZ;
  assign data_in = bidir_port;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_dir <= 0;
      else if (chipselect && ~write_n && (address == 1))
          data_dir <= writedata[3 : 0];
    end



endmodule