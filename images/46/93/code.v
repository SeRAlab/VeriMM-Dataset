module top_module(
  input clk,
  input rst,
  input we,
  input [31:0] addr,
  input [data_width-1:0] din,
  input [bank_sel_width-1:0] bank_sel,
  output [data_width-1:0] dout
);parameter data_width = 32; // width of the data bus in bits
parameter mem_size = 1024; // size of the memory in bytes
parameter mem_type = "DDR"; // type of memory (DDR, SDRAM, SRAM, or Flash)

parameter bank_sel_width = 2; // width of the bank select signal, if applicable

// additional parameters and IO definitions specific to the selected memory type and bank configuration

// Define internal signals and registers
reg [data_width-1:0] mem[mem_size/data_width-1:0];
reg [data_width-1:0] dout_reg;
reg [31:0] addr_reg;
reg [bank_sel_width-1:0] bank_sel_reg;

// Read and write operations
always @(posedge clk) begin
  if (rst) begin
    addr_reg <= 0;
    bank_sel_reg <= 0;
    dout_reg <= 0;
  end else begin
    addr_reg <= addr;
    bank_sel_reg <= bank_sel;
    if (we) begin
      mem[addr_reg][data_width-1:0] <= din;
    end else begin
      dout_reg <= mem[addr_reg][data_width-1:0];
    end
  end
end

// Output data
assign dout = dout_reg;

endmodule