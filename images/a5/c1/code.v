module top_module(
  input wire clk_in,
  input wire rst_in,
  input wire [n-1:0] data_in,
  output reg [n-1:0] data_out
);parameter n = 8; // number of bits in the data signal
parameter t = 2; // number of clock cycles for synchronization

reg [n-1:0] ff1_out;
reg [n-1:0] ff2_out;

wire enable;

assign enable = ~(&{clk_in, rst_in});

integer i = 0; // Initialize i

always @(posedge clk_in or posedge rst_in) begin
  if (rst_in) begin
    ff1_out <= 0;
    i <= 0; // Reset the counter
  end else begin
    ff1_out <= data_in;
  end
end

always @(posedge clk_in or posedge rst_in) begin
  if (rst_in) begin
    ff2_out <= 0;
    i <= 0; // Reset the counter
  end else if (i < t) begin
    i <= i + 1;
  end else begin
    ff2_out <= ff1_out;
    i <= 0;
  end
end

always @(posedge clk_in or posedge rst_in) begin
  if (rst_in) begin
    data_out <= 0;
  end else if (enable) begin
    data_out <= ff2_out;
  end
end

endmodule