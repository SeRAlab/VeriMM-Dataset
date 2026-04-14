module top_module(
    input clk,
    input rst,

    input [143:0] port0_ci,
    input [143:0] port1_ci,
    input [143:0] port2_ci,
    input [143:0] port3_ci,
    input [143:0] port4_ci,

    output reg [143:0] port0_co,
    output reg [143:0] port1_co,
    output reg [143:0] port2_co,
    output reg [143:0] port3_co,
    output reg [143:0] port4_co,

    input port4_ready,
    output reg port4_ack,

    output reg [143:0] control_w
);always @(posedge clk) begin
    if (rst) begin
        port0_co <= 144'h0;
        port1_co <= 144'h0;
        port2_co <= 144'h0;
        port3_co <= 144'h0;
        port4_co <= 144'h0;
        port4_ack <= 0;
        control_w <= 144'h0;
    end else begin
        port0_co <= port0_ci;
        port1_co <= port1_ci;
        port2_co <= port2_ci;
        port3_co <= port3_ci;
        port4_co <= port4_ci;
        port4_ack <= port4_ready;
        control_w <= port0_ci | port1_ci | port2_ci | port3_ci | port4_ci;
    end
end

endmodule