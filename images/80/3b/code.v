module top_module(
  input wire clka,
  input wire ena,
  input wire [3:0] addra,
  input wire [3:0] dina,
  output reg [3:0] douta  // Changed from wire to reg
);reg [3:0] mem [0:15];

  always @(posedge clka) begin
    if (ena) begin
      mem[addra] <= dina;
    end
    douta <= mem[addra];
  end

endmodule