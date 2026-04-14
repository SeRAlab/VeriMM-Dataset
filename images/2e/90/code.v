module noise_suppression (
    input clk,
    input reset,
    input noisy_signal,
    output reg clean_signal
);
    reg [1:0] state;
    reg [3:0] count;

    parameter IDLE = 2'b00;
    parameter CLEAN = 2'b01;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            clean_signal <= 0;
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (noisy_signal) begin
                        count <= count + 1;
                        if (count == 4'd10) begin // Wait for 10 cycles
                            state <= CLEAN;
                            clean_signal <= 1; // Output clean signal
                        end
                    end else begin
                        count <= 0; // Reset count if noise detected
                    end
                end
                CLEAN: begin
                    if (!noisy_signal) begin
                        state <= IDLE;
                        clean_signal <= 0; // Stop clean signal
                        count <= 0;
                    end
                end
            endcase
        end
    end
endmodule