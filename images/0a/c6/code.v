module temp_shutdown (
    input wire clk,
    input wire rst,
    input wire [7:0] temp,      // 8-bit temperature input
    input wire [7:0] threshold,  // 8-bit temperature threshold
    output reg shutdown_signal    // Shutdown signal output
);
    reg [1:0] state;            // State variable
    parameter IDLE = 2'b00,     // Idle state
              SHUTDOWN = 2'b01, // Shutdown state
              WAIT = 2'b10;     // Wait state

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            shutdown_signal <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (temp > threshold) begin
                        shutdown_signal <= 1;
                        state <= SHUTDOWN;
                    end
                end
                SHUTDOWN: begin
                    // Remain in shutdown state until checked
                    if (temp <= threshold) begin
                        state <= WAIT;
                    end
                end
                WAIT: begin
                    // After waiting, go back to IDLE state
                    shutdown_signal <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule