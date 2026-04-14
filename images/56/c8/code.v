module top_module(
  input [6:0] length,
  input [127:0] block_in,
  output reg [127:0] block_out  // Changed from wire to reg
);reg [127:0] mask;
  reg [127:0] masked_data;
  reg [127:0] padded_data;

  // Generate bitmask used to add zeros to part of block not being data.
  always @(*)
  begin
    mask = 127'b0;
    if (length[0])
      mask = {1'b1, mask[127:1]};
    if (length[1])
      mask = {2'h3, mask[127:2]};
    if (length[2])
      mask = {4'hf, mask[127:4]};
    if (length[3])
      mask = {8'hff, mask[127:8]};
    if (length[4])
      mask = {16'hffff, mask[127:16]};
    if (length[5])
      mask = {32'hffffffff, mask[127:32]};
    if (length[6])
      mask = {64'hffffffff_ffffffff, mask[127:64]};
  end

  // Pad the block by setting the first non-data bit after the data to 1.
  always @(*)
  begin
    masked_data = block_in & mask;
    padded_data = masked_data;
    padded_data[(127 - length)] = 1'b1;
    block_out = padded_data;  // This is now valid since block_out is reg
  end

endmodule