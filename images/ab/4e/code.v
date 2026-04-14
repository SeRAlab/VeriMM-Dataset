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

reg [11:0] mem [0:10403];

// Read operation
assign douta = mem[addra];

// Write operation
always @(posedge clka) begin
    if (wea == 1) begin
        mem[addra] <= dina;
    end
end

endmodule