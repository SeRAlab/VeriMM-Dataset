module top_module(
  input [n-1:0] din,
  input wen,
  input ren,
  input rst,
  input clk,
  output reg [n-1:0] dout,
  output reg empty,
  output reg full
);parameter n = 8; // number of bits in the data signals
parameter depth = 16; // number of data elements that can be stored in the memory block

reg [n-1:0] mem [0:depth-1]; // memory block implemented as an array of data elements
reg [4:0] head = 0; // pointer to the next available location for writing
reg [4:0] tail = 0; // pointer to the oldest data element in the memory block
reg [4:0] count = 0; // number of data elements currently stored in the memory block

always @(posedge clk) begin
  if (rst) begin
    head <= 0;
    tail <= 0;
    count <= 0;
    dout <= 0;
  end else begin
    if (wen && !full) begin
      mem[head] <= din;
      head <= (head == depth-1) ? 0 : head + 1;
      count <= count + 1;
    end
    if (ren && !empty) begin
      dout <= mem[tail];
      tail <= (tail == depth-1) ? 0 : tail + 1;
      count <= count - 1;
    end
    empty <= (count == 0); // update empty flag
    full <= (count == depth); // update full flag
  end
end

endmodule