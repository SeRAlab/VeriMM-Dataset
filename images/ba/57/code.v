module top_module(
  input [7:0] ram,
  input ram_e,
  input [7:0] eram,
  input u_ram_e,
  input [7:0] pio8255,
  input pio8255_e,
  input [7:0] io,
  input io_e,
  input [7:0] fdc,
  input fdc_e,
  output reg [7:0] D
);always @(*) begin
    if (ram_e) D = ram;
    else if (u_ram_e) D = eram;
    else if (pio8255_e) D = pio8255;
    else if (io_e) D = io;
    else if (fdc_e) D = fdc;
    else D = 8'd255;
  end

endmodule