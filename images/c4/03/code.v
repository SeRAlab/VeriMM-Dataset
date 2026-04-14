module lut_mem_block(
  input wire clka,
  input wire ena,
  input wire [3:0] addra,
  input wire [3:0] dina,
  output wire [3:0] douta
);

  reg [3:0] mem [0:15];
  wire [3:0] douta;

  always @(posedge clka) begin
    if (ena) begin
      mem[addra] <= dina;
    end
    douta <= mem[addra];
  end

endmodule