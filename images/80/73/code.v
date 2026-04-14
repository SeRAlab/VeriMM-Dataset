module top_module(douta,
    clka,
    addra,
    dina,
    wea);output reg [11:0] douta;  // Changed to reg type
  input clka;
  input [6:0] addra;
  input [11:0] dina;
  input [0:0] wea;

  reg [11:0] mem [0:127]; // 128 memory locations, each 12 bits wide

  always @(posedge clka) begin
    if (wea == 1'b1) begin
      mem[addra] <= dina;
    end
    douta <= mem[addra]; // douta can now be assigned since it's a reg type
  end
endmodule