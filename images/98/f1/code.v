module top_module(clka, wea, addra, dina, douta);parameter WIDTH = 12;
  parameter DEPTH = 256;
  
  input clka;
  input wea;
  input [7:0] addra;
  input [WIDTH-1:0] dina;
  output [WIDTH-1:0] douta;
  
  reg [WIDTH-1:0] mem [0:DEPTH-1];
  
  assign douta = (addra >= DEPTH) ? 0 : mem[addra];
  
  always @(posedge clka) begin
    if (wea && addra < DEPTH)
      mem[addra] <= dina;
  end
endmodule