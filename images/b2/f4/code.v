module top_module(
    input clk,
    input [63:0] probe0,
    input [63:0] probe1,
    input [0:0] probe2,
    input [0:0] probe3,
    input [0:0] probe4,
    input [3:0] probe5,
    output reg [63:0] out_probe0,
    output reg [0:0] out_probe2,
    output reg [3:0] out_probe3
);reg [63:0] reg1;
  reg [0:0] reg2;
  reg [3:0] reg3;

  always @(posedge clk) begin
    reg1 <= probe0 + probe1;
    reg2 <= probe2 + probe3;
    reg3 <= probe4 + probe5;
    out_probe0 <= reg1; // Corrected to assign to output
    out_probe2 <= reg2; // Corrected to assign to output
    out_probe3 <= reg3; // Corrected to assign to output
  end
endmodule