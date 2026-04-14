module temp_shutdown(
    input wire clk,
    input wire reset,
    input wire [7:0] current_temp,
    input wire [7:0] threshold_temp,
    output reg shutdown_signal
);
    reg [1:0] state; // 2-bit state to count consecutive cycles
    parameter IDLE = 2'b00, HIGH = 2'b01, SHUTDOWN = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown_signal <= 0;
            state <= IDLE;
        end else begin
            if (current_temp > threshold_temp) begin
                if (state == HIGH) begin
                    state <= SHUTDOWN;
                    shutdown_signal <= 1;
                end else begin
                    state <= HIGH;
                    shutdown_signal <= 0;
                end
            end else begin
                state <= IDLE;
                shutdown_signal <= 0;
            end
            
            if (state == SHUTDOWN) begin
                // Remain in shutdown state
                shutdown_signal <= 1;
            end
        end
    end
endmodule