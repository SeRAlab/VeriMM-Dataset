module top_module(
  // inputs:
  address,
  chipselect,
  clk,
  in_port,
  reset_n,
  write_n,
  writedata,

  // outputs:
  irq,
  readdata
);output irq;
  output [31:0] readdata;
  input [1:0] address;
  input chipselect;
  input clk;
  input in_port;
  input reset_n;
  input write_n;
  input [31:0] writedata;

  wire clk_en;
  wire data_in;
  wire irq;
  reg irq_mask;
  wire read_mux_out;
  reg [31:0] readdata;
  
  assign clk_en = 1;

  //s1, which is an e_avalon_slave
  assign read_mux_out = ({1 {(address == 0)}} & data_in) |
    ({1 {(address == 2)}} & irq_mask);

  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 0) begin
      readdata <= 0;
      irq_mask <= 0;
    end
    else if (clk_en) begin
      case (address)
        0: begin
          if (chipselect && ~write_n)
            readdata <= in_port;
        end
        2: begin
          if (chipselect && ~write_n)
            irq_mask <= writedata;
        end
        default: begin
          readdata <= 'bx;
        end
      endcase
    end
  end

  assign data_in = in_port;
  always @(posedge clk or negedge reset_n) begin
    if (reset_n == 0)
      irq_mask <= 0;
    else if (chipselect && ~write_n && (address == 2))
      irq_mask <= writedata;
  end

  assign irq = |(data_in & irq_mask);

endmodule