module top_module(
  input clk, // clock signal
  input we, // write enable signal
  input ce, // chip enable signal
  input [n-1:0] din, // data input signal
  input [addr_width-1:0] addr, // address input signal
  output reg [n-1:0] dout // data output signal
);parameter n = 8; // number of bits in the data input and output
parameter m = 256; // number of addresses (i.e., depth of the memory)
parameter addr_width = $clog2(m); // Calculate address width using $clog2

reg [n-1:0] mem [0:m-1]; // memory array

always @(posedge clk) begin
  if (ce == 1'b0) begin // chip enable signal is low
    dout <= 'bx; // output is undefined
  end else begin
    if (we == 1'b1) begin // write enable signal is high
      mem[addr] <= din; // write data to memory
    end else begin // write enable signal is low
      dout <= mem[addr]; // read data from memory and output it
    end
  end
end

endmodule