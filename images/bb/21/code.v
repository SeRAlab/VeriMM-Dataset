module top_module(douta,
    clka,
    addra,
    dina,
    wea);output reg [2:0] douta; // Change output to reg type
  input clka;
  input [12:0] addra;
  input [2:0] dina;
  input [0:0] wea;

  reg [2:0] mem [0:8191];
  
  always @(posedge clka) begin
    if (wea) begin
      mem[addra[12:1]] <= dina; // Fix array indexing
    end
    douta <= mem[addra[12:1]]; // Fixed douta assignment to read memory
  end
endmodule