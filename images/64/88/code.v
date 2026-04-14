module top_module(output reg [35:0] douta,  // changed to output reg
   input clka,
   input [9:0] addra);reg [35:0] mem [0:1023];

  integer i;

  initial begin
    for (i = 0; i < 1024; i = i + 1) begin
      mem[i] = $random;
    end
  end

  always @(posedge clka) begin
    douta <= mem[addra];
  end

endmodule