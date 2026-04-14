module top_module(
    input clk,
    input rst,
    input sel0,
    input sel1,
    input [143:0] port0_ci,
    input [143:0] port1_ci,
    input [143:0] port2_ci,
    input [143:0] port3_ci,
    output reg [143:0] port_co
    );always @(posedge clk, posedge rst) begin
    if (rst) begin
      port_co <= 144'h000000000000000000000000000000000000;
    end else begin
      case ({sel1, sel0})
        2'b00: port_co <= port0_ci;
        2'b01: port_co <= port1_ci;
        2'b10: port_co <= port2_ci;
        2'b11: port_co <= port3_ci;
      endcase
    end
  end

endmodule