module top_module(
  clk, rst, enb,
  clk10,
  entradas,
  salida
);parameter PwrC=0;

parameter cantidadBits = 10;


input wire clk;
input wire enb;
input wire rst;


input wire clk10;




input wire [cantidadBits-1:0] entradas;


output reg salida;










reg [3:0] contador;








always @ ( * ) begin
salida = ~rst & enb ? entradas[contador] : 0;
end


always @(posedge clk) begin
  
  
  
  if (rst) begin
    
    
    
    contador <= 0;
  end else if(enb) begin
    
    
    
    contador <= contador == 0 ? cantidadBits-1 : contador-1;
  end
  else  contador = contador;
  end

  
  
  `ifdef SIMULATION_conductual
    always @(posedge salida) testbench_P1.probador.m1.PwrCntr[PwrC]<=testbench_P1.probador.m1.PwrCntr[PwrC]+1;
  `endif

endmodule