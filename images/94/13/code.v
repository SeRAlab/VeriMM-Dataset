module top_module(
  input clk,
  input resetn,
  input [3:0] d,
  input [1:0] byteena,
  output reg [15:0] q
);reg [3:0] reg0;
  reg [3:0] reg1;
  reg [3:0] reg2;
  reg [3:0] reg3;

  always @(posedge clk) begin
    if (!resetn) begin
      reg0 <= 4'b0;
      reg1 <= 4'b0;
      reg2 <= 4'b0;
      reg3 <= 4'b0;
    end else begin
      if (byteena[0]) begin
        reg0[3:0] <= d[3:0];
        reg1[3:0] <= d[7:4];
        reg2[3:0] <= d[11:8];
        reg3[3:0] <= d[15:12];
      end
      if (byteena[1]) begin
        reg0[7:4] <= d[3:0];
        reg1[7:4] <= d[7:4];
        reg2[7:4] <= d[11:8];
        reg3[7:4] <= d[15:12];
      end
    end
  end

  assign q = {reg3, reg2, reg1, reg0};

endmodule