module memory_block_generator(clka, ena, wea, addra, dina, douta);

  parameter MEM_SIZE = 8192;
  parameter DATA_WIDTH = 13;
  
  input clka;
  input ena;
  input wea;
  input [DATA_WIDTH-1:0] dina;
  input [MEM_SIZE-1:0] addra;
  output [DATA_WIDTH-1:0] douta;
  
  reg [DATA_WIDTH-1:0] mem [MEM_SIZE-1:0];
  
  always @(posedge clka) begin
    if (ena) begin
      if (wea) begin
        mem[addra] <= dina;
      end
      douta <= mem[addra];
    end
  end
  
endmodule