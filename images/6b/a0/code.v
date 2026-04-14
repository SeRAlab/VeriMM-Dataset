module top_module(douta,
    clka,
    addra);output reg [35:0] douta; // Changed to output reg
  input clka;
  input [9:0] addra;

  reg [35:0] mem [0:1023];

  always @(posedge clka) begin
    douta <= mem[addra];
  end

  always @(posedge clka) begin
    mem[addra] <= douta;
  end

endmodule