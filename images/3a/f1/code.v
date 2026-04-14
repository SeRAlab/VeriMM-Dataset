module power_gating_controller (
    input wire clk,
    input wire power_ctrl,
    output reg state
);

always @(posedge clk) begin
    if (power_ctrl) begin
        state <= 1'b1; // Power on
    end else begin
        state <= 1'b0; // Power off
    end
end

endmodule