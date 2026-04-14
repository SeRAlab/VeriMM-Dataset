module state_space_controller(
    input clk,
    input reset,
    input start,
    input stop,
    output reg [1:0] state // 00: IDLE, 01: RUN, 10: STOP
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter RUN = 2'b01;
    parameter STOP = 2'b10;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= RUN;
                end
                RUN: begin
                    if (stop) state <= STOP;
                end
                STOP: begin
                    if (!stop) state <= IDLE; // Return to IDLE
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule