module top_module(
  input clk,
  input wr_en,
  input rd_en,
  input [data_width-1:0] write_data,
  input [address_width-1:0] address,
  output reg [data_width-1:0] read_data // Changed to reg
);parameter data_width = 32; // width of the data to be stored in the cache memory
parameter address_width = 16; // width of the address of the data to be accessed
parameter block_size = 64; // size of the cache memory block
parameter num_blocks = 256; // number of blocks in the cache memory

reg [data_width-1:0] data_array [0:num_blocks-1][0:block_size-1]; // data array
reg [address_width-1:0] tag_array [0:num_blocks-1]; // tag array
reg [0:0] valid_bit_array [0:num_blocks-1]; // valid bit array changed to one dimension

// Calculate log2 of block_size using a fixed value as it is known at compile-time
localparam block_offset = $clog2(block_size); // Pre-compute log2(block_size)

always @(posedge clk) begin
  if (wr_en) begin // write operation
    data_array[tag_array[address[address_width-1:block_offset]]] [address[block_offset-1:0]] <= write_data;
    valid_bit_array[tag_array[address[address_width-1:block_offset]]] <= 1; // changed indexing
  end
  else if (rd_en) begin // read operation
    if (valid_bit_array[tag_array[address[address_width-1:block_offset]]] == 1) begin // data is present in the cache memory
      read_data <= data_array[tag_array[address[address_width-1:block_offset]]] [address[block_offset-1:0]]; // corrected indexing
    end
    else begin // data is not present in the cache memory
      // read data from main memory and update data array and tag array
      // ...
    end
  end
end

endmodule