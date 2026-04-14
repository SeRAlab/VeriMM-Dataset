module top_module(
  input [10:0] addra,
  input clka,
  input [11:0] dina,
  output reg [11:0] douta,
  input wea
);reg [11:0] mem[0:2047];

  always @(posedge clka) begin
    if (wea) begin
      mem[addra] <= dina;
    end
    douta <= mem[addra];
  end

endmodule