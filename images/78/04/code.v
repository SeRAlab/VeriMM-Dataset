module top_module(douta,
    clka,
    addra);output reg [7:0] douta; // Changed to reg to allow assignment in always block
  input clka;
  input [9:0] addra;

  reg [7:0] mem [0:1023]; // create block memory
  integer i;

  always @(posedge clka) begin
    douta <= mem[addra]; // output memory data at specified address
  end

  // initialize memory with sequential values
  initial begin
    for (i = 0; i < 1024; i = i + 1) begin
      mem[i] = i; // assign sequential value to memory location
    end
  end
endmodule