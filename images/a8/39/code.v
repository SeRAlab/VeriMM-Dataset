module top_module(output reg [35:0] douta,
    input clka,
    input [9:0] addra);reg [35:0] mem [0:1023];
  integer i;

  initial begin
    // populate memory with data
    for (i = 0; i <= 1023; i = i + 1) begin
      mem[i] = i;
    end
  end

  always @(posedge clka) begin
    douta <= mem[addra];
  end

endmodule