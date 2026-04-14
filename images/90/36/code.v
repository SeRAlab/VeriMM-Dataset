module top_module(
  input clk,
  input [63:0]probe0,
  input [63:0]probe1,
  input [7:0]probe2,
  input [7:0]probe3,
  input [7:0]probe4,
  input [7:0]probe5,
  input [7:0]probe6,
  input [7:0]probe7,
  input [63:0]probe8,
  input [31:0]probe9,
  input [7:0]probe13,
  input [63:0]probe14,
  input [31:0]probe15
);always @(posedge clk) begin
    $display("probe0: %h", probe0);
    $display("probe1: %h", probe1);
    $display("probe2: %h", {56'b0, probe2});
    $display("probe3: %h", {56'b0, probe3});
    $display("probe4: %h", {56'b0, probe4});
    $display("probe5: %h", {56'b0, probe5});
    $display("probe6: %h", {56'b0, probe6});
    $display("probe7: %h", {56'b0, probe7});
    $display("probe8: %h", probe8);
    $display("probe9: %h", {32'b0, probe9});
    $display("probe10: %h", 8'b0);
    $display("probe11: %h", 8'b0);
    $display("probe12: %h", 8'b0);
    $display("probe13: %h", probe13);
    $display("probe14: %h", probe14);
    $display("probe15: %h", {32'b0, probe15});
    $display("probe16: %h", 8'b0);
    $display("probe17: %h", 8'b0);
    $display("probe18: %h", 8'b0);
    $display("probe19: %h", 8'b0);
  end

endmodule