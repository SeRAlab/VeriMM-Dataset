module block_mem_generator
   (douta,
    addra,
    clka,
    dina,
    wea);
    
  output reg [11:0] douta;
  input [13:0] addra;
  input clka;
  input [11:0] dina;
  input wea;

  reg [11:0] mem [0:16383];
  
  always @(posedge clka) begin
    if(wea) begin
      mem[addra] <= dina;
    end else begin
      douta <= mem[addra];
    end
  end
endmodule