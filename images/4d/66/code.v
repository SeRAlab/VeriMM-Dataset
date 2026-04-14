module top_module(clka, wea, addra, dina, douta);/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[10:0],dina[11:0],douta[11:0]" */
  input clka;
  input [0:0] wea;
  input [10:0] addra;
  input [11:0] dina;
  output reg [11:0] douta; // Changed output to reg type

  reg [11:0] shadow_reg [0:1023]; // 1024 12-bit shadow registers

  always @(posedge clka) begin
    if (wea) begin
      shadow_reg[addra] <= dina;
    end
    douta <= shadow_reg[addra];
  end
endmodule