module top_module(
  input [n-1:0] data_in,
  input [m-1:0] search_key,
  output reg match,                // Changed to reg type
  output reg [n-1:0] data_out      // Changed to reg type
);parameter n = 8; // number of bits in data
parameter m = 4; // number of bits in search key

reg [n-1:0] stored_data;

always @ (search_key, data_in) begin
  if (search_key == stored_data) begin
    match = 1;
    data_out = stored_data;
  end else begin
    match = 0;
    data_out = 0;
  end
end

endmodule