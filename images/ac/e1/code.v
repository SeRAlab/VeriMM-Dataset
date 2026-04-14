module top_module(
  clka,
  wea,
  addra,
  dina,
  douta
);input wire clka;
input wire [0 : 0] wea;
input wire [12 : 0] addra;
input wire [11 : 0] dina;
output wire [11 : 0] douta;

reg [11:0] mem [0:5588];

always @(posedge clka) begin
  if(wea == 1'b1) begin
    mem[addra] <= dina;
  end
end

assign douta = mem[addra];

endmodule