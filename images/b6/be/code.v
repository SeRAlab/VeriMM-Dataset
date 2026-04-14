module top_module(douta,
    addra,
    clka,
    dina,
    wea);output reg [11:0] douta; // Change output to reg to store state
  input [12:0] addra;
  input clka;
  input [11:0] dina;
  input [0:0] wea;

  reg [11:0] mem [0:8191]; // Changed wire to reg for memory

  always @(posedge clka) begin
    if (wea) begin
      mem[addra[12:1]] <= dina; // Corrected memory assignment
    end
    douta <= mem[addra[12:1]]; // Removed redundant indexing
  end

endmodule