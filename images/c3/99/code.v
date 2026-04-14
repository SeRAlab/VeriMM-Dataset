module block_mem_gen
   #(parameter WIDTH = 32, DEPTH = 1024)
   (douta,
    clka,
    addra);
    
  output reg [WIDTH-1:0] douta;
  input clka;
  input [9:0] addra;

  reg [WIDTH-1:0] mem_init [0:DEPTH-1];

  integer i;

  initial begin
    for (i = 0; i < DEPTH; i = i + 1) begin
      mem_init[i] = 32'h00000000;
    end
  end

  always @(posedge clka) begin
    if (addra < DEPTH) begin
      douta <= mem_init[addra];
    end else begin
      douta <= 0;
    end
  end

endmodule