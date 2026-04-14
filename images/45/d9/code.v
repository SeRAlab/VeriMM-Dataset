module top_module(output reg [WIDTH-1:0] douta,  // Added direction declaration for douta
    input clka,
    input [11:0] addra,
    input [WIDTH-1:0] dina,
    input wea);parameter WIDTH = 12;
  parameter DEPTH = 2048;

  reg [WIDTH-1:0] mem [DEPTH-1:0];

  always @(posedge clka) begin
    if (wea) begin
      mem[addra] <= dina;
    end
    douta <= mem[addra];
  end

endmodule