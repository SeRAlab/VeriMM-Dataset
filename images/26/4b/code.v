module mpc_state_machine (
    input clk,
    input reset,
    input start,
    output reg [1:0] state // 00: IDLE, 01: RUNNING, 10: FINISHED
);
    parameter RUN_TIME = 4; // Number of clock cycles in RUNNING state
    reg [2:0] counter; // to count time in RUNNING state

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // IDLE
            counter <= 0;
        end else begin
            case (state)
                2'b00: begin // IDLE
                    if (start) begin
                        state <= 2'b01; // Transition to RUNNING
                        counter <= 0;
                    end
                end
                2'b01: begin // RUNNING
                    if (counter < RUN_TIME - 1) begin
                        counter <= counter + 1; // increment counter
                    end else begin
                        state <= 2'b10; // Transition to FINISHED
                    end
                end
                2'b10: begin // FINISHED
                    // Options to go back to IDLE or stay
                    state <= 2'b00; // Automatically go back to IDLE for this example
                end
            endcase
        end
    end
endmodule