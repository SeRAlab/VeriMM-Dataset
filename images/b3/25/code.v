module top_module(
  input wire Vdd,
  input wire Rload,
  input wire Iconst,
  output wire Vload
);reg [31:0] Vload_reg;
  reg [31:0] Iload_reg;
  reg [31:0] Vdrop_reg;
  
  assign Vload = Vload_reg;
  
  always @ (Vdd or Rload or Iconst or Vload_reg) begin
    Vdrop_reg = Iconst * Rload;
    Iload_reg = Vdd / Rload;
    Vload_reg = Vload_reg + (Iload_reg * (Vdd - Vload_reg) - Vdrop_reg) / 1000;
  end
  
endmodule