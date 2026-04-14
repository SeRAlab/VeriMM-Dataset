module top_module(
  input clka,
  input ena,
  input wea,
  input [11:0] addra,
  input [15:0] dina,
  output reg [15:0] douta  // Changed to output reg
);reg [15:0] mem [0:4095];

  always @(posedge clka) begin
    if (ena) begin
      if (wea) begin
        mem[addra] <= dina;
      end else begin
        douta <= mem[addra];
      end
    end
  end

endmodule