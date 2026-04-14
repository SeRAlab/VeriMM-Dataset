module top_module(
    input clk,
    input rst,
    input motor_ctrl,
    output reg motor_state
);always @(posedge clk, posedge rst) begin
    if (rst) begin
        motor_state <= 0;
    end else begin
        if (motor_ctrl) begin
            motor_state <= 1;
        end else begin
            motor_state <= 0;
        end
    end
end

endmodule