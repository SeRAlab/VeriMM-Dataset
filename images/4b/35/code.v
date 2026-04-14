module top_module(
  clka,
  wea,
  addra,
  dina,
  douta
);input wire clka;
input wire [0 : 0] wea;
input wire [13 : 0] addra;
input wire [11 : 0] dina;
output wire [11 : 0] douta;

reg [11:0] mem [0:11024];
reg [11:0] douta_reg;

always @(posedge clka) begin
  if (wea == 1'b1) begin
    mem[addra] <= dina;
  end
  douta_reg <= mem[addra];
end

assign douta = douta_reg;

endmodule