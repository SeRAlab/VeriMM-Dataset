module memory_generator
   (douta,
    clka,
    addra,
    dina,
    wea);
  output [11:0] douta;
  input clka;
  input [14:0] addra;
  input [11:0] dina;
  input [0:0] wea;

  reg [11:0] ram [0:16383];
  reg [11:0] douta;
  integer i;

  always @(posedge clka) begin
    if (wea) begin
      ram[addra[14:0]] <= dina;
    end
    douta <= ram[addra[14:0]];
  end

endmodule