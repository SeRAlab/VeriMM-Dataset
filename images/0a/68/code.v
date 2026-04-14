module sata_controller (
    input clk,
    input reset,
    input start,
    input sleep,
    input wakeup,
    input end_signal,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter ACTIVE = 2'b01;
    parameter SLEEP = 2'b10;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= ACTIVE;
                end
                ACTIVE: begin
                    if (sleep) state <= SLEEP;
                    else if (end_signal) state <= IDLE;
                end
                SLEEP: begin
                    if (wakeup) state <= ACTIVE;
                end
            endcase
        end
    end
endmodule