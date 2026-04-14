module top_module(
clk,
rstn
);input clk, rstn;

wire clk;
wire rstn;



wire [3:0] a;
wire [3:0] b;
reg status;
reg [31:0] c[3:0];

  always @(posedge clk) begin
    if({b[1],a[3:2]} == 3'b 001) begin
      status <= 1'b 1;
      c[0] <= 16'h FFFF;
    end
  end


endmodule