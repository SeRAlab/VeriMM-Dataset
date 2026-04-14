module top_module(
  clka,
  ena,
  wea,
  addra,
  dina,
  douta
);input clka;
input ena;
input [1 : 0] wea;
input [9 : 0] addra;
input [15 : 0] dina;
output reg [15 : 0] douta; // Changed to reg

//============
// RAM
//============

reg [15:0] mem[0:16383];

always @(posedge clka) begin
    if (ena) begin
        if (wea == 2'b01) // byte write
            mem[addra][7:0] <= dina[7:0];
        else if (wea == 2'b10) // half-word write
            mem[addra][15:0] <= dina[15:0];
        else if (wea == 2'b11) // word write
            mem[addra] <= dina;
    end
    douta <= mem[addra];
end

endmodule