module top_module(output reg [11:0] douta,  // Change douta to output reg
    input clka,
    input [10:0] addra,
    input [11:0] dina,
    input [0:0] wea);reg [11:0] mem [0:2047];

  always @(posedge clka) begin
    if (wea) begin
      mem[addra] <= dina;
    end
    douta <= mem[addra];
  end
endmodule