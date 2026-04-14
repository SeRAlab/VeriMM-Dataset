module top_module(douta,
    ena,
    clka,
    addra,
    dina,
    wea);output [7:0]douta;
  input ena;
  input clka;
  input [11:0]addra;
  input [7:0]dina;
  input [0:0]wea;

  reg [7:0] mem [0:4095];
  reg [7:0] douta;
  
  always @(posedge clka) begin
    if (ena) begin
      if (wea) begin
        mem[addra] <= dina;
      end
      douta <= mem[addra];
    end
  end
  
endmodule