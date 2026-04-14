module top_module(
  input clk, // clock signal
  input rst, // reset signal
  input en, // enable signal
  input [addr_width-1:0] addr, // address signal
  input wr_en, // write enable signal
  input [data_width-1:0] data_in, // data input signal
  output [data_width-1:0] data_out // data output signal
);parameter mem_type = "SRAM"; // memory type
parameter data_width = 32; // data bus width
parameter addr_width = 16; // address bus width

// Define internal signals
reg [data_width-1:0] mem_data; // Memory data
reg [addr_width-1:0] mem_addr; // Memory address
reg mem_wr_en; // Memory write enable
reg mem_rd_en; // Memory read enable

// Synchronous memory read/write
always @(posedge clk) begin
  if (rst) begin
    mem_wr_en <= 0;
    mem_rd_en <= 0;
    mem_addr <= 0;
    mem_data <= 0;
  end
  else begin
    if (en) begin
      mem_addr <= addr;
      if (wr_en) begin
        mem_wr_en <= 1;
        mem_data <= data_in;
      end
      else begin
        mem_wr_en <= 0;
        mem_data <= 0;
        mem_rd_en <= 1;
      end
    end
    else begin
      mem_wr_en <= 0;
      mem_rd_en <= 0;
      mem_data <= 0;
    end
  end
end

// Assign memory output to data_out
assign data_out = mem_data;

endmodule