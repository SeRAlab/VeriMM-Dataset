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
  input   [  9: 0] in_port;
  input            reset_n;

  wire             clk_en;
  wire    [  9: 0] data_in;
  wire    [  9: 0] read_mux_out;
  reg     [ 31: 0] readdata;
  reg     [  9: 0] reg1;
  reg     [  9: 0] reg2;
  assign clk_en = 1;

  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          begin
            readdata <= 0;
            reg1 <= 0;
            reg2 <= 0;
          end
      else if (clk_en)
          readdata <= {32'b0 | read_mux_out};
    end

  assign data_in = (address == 2'b00) ? in_port :
                   (address == 2'b01) ? reg1 :
                   (address == 2'b10) ? reg2 :
                   (address == 2'b11) ? in_port & reg1 : 10'b0;

  assign read_mux_out = (address == 2'b00) ? data_in :
                        (address == 2'b01) ? reg1 :
                        (address == 2'b10) ? reg2 :
                        (address == 2'b11) ? in_port & reg1 : 10'b0;

  always @(posedge clk)
    begin
      if (reset_n == 0)
          begin
            reg1 <= 0;
            reg2 <= 0;
          end
      else
          begin
            case (address)
              2'b01: reg1 <= in_port;
              2'b10: reg2 <= in_port;
              2'b11: reg1 <= in_port;
            endcase
          end
    end

endmodule