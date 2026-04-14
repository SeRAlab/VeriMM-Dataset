module top_module(
  input clk,
  input rst,
  input [15:0] addr,
  input [7:0] data_in,
  input write_en,
  output reg [7:0] data_out
);reg [7:0] mem[0:65535];
  
  always @(posedge clk) begin
    if (rst) begin
      data_out <= 0;
    end
    else begin
      if (write_en) begin
        if (addr >= 0 && addr <= 4095) begin
          mem[addr] <= data_in;
        end
        else if (addr >= 8192 && addr <= 12287) begin
          mem[addr] <= data_in;
        end
        else if (addr >= 16384 && addr <= 20479) begin
          mem[addr] <= data_in;
        end
        else begin
          mem[addr] <= 0;
        end
      end
      data_out <= mem[addr];
    end
  end
  
endmodule