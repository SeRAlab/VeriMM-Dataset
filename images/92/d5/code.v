module top_module(douta,
   clka,
   addra,
   dina,
   wea);output [11:0] douta;
  input clka;
  input [9:0] addra;
  input [11:0] dina;
  input [0:0] wea;

  reg [11:0] mem [0:1023];
  reg [11:0] douta_reg;

  always @(posedge clka) begin
    if (wea) begin
      mem[addra] <= dina;
    end else begin
      douta_reg <= mem[addra];
    end
  end

  assign douta = douta_reg;

endmodule