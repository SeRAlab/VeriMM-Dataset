module top_module(
    input clk,
    input rst,
    input [6:0] kc,
    input [5:0] kf,
    input [3:0] mul,
    input [2:0] dt1,
    input [1:0] dt2,
    input signed [7:0] pm,
    input [2:0] pms,
    output reg signed [15:0] pg_phase
);always @(posedge clk, posedge rst) begin
    if (rst) begin
        pg_phase <= 0;
    end else begin
        pg_phase <= ((kc * kf * mul * (1 + dt1 + dt2)) + (pm * pms));
    end
end

endmodule