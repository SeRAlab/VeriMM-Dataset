module top_module(
  input rw,
  input [n-1:0] addr,
  input [m-1:0] data_in,
  input clk,
  output [m-1:0] data_out,
  output valid
);parameter n = 16; // number of storage locations
parameter m = 32; // number of bits in each storage location
parameter k = 8; // number of bits in each tag

reg [m-1:0] storage [n-1:0]; // storage locations
reg [k-1:0] tags [n-1:0]; // tags
reg [m-1:0] main_memory [n-1:0]; // main_memory declaration

reg [m-1:0] data_out_reg; // register to hold read data
reg valid_reg; // register to hold valid signal

always @(posedge clk) begin
  if (rw) begin // write operation
    storage[addr] <= data_in;
  end else begin // read operation
    if (tags[addr] == addr[k-1:0]) begin // cache hit
      data_out_reg <= storage[addr];
      valid_reg <= 1'b1;
    end else begin // cache miss
      data_out_reg <= main_memory[addr]; // fetch data from main memory
      valid_reg <= 1'b0;
      storage[addr] <= main_memory[addr]; // store data in cache
      tags[addr] <= addr[k-1:0]; // update tag
    end
  end
end

assign data_out = data_out_reg;
assign valid = valid_reg;

endmodule