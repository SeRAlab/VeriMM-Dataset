module top_module(douta,
   ena,
   clka,
   addra,
   dina,
   wea);output [7:0] douta;
  input ena;
  input clka;
  input [11:0] addra;
  input [7:0] dina;
  input [0:0] wea;

  reg [7:0] mem [0:4095];
  reg [7:0] douta_reg;
  wire [11:0] addra_reg;
  wire [7:0] dina_reg;
  wire [0:0] wea_reg;

  assign addra_reg = addra;
  assign dina_reg = dina;
  assign wea_reg = wea;

  always @(posedge clka) begin
    if (ena) begin
      if (wea_reg) begin
        mem[addra_reg] <= dina_reg;
      end
      douta_reg <= mem[addra_reg];
    end
  end

  assign douta = douta_reg;

endmodule