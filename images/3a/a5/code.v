module temp_shutdown (
    input clk,
    input reset,
    input [3:0] temperature,
    output reg shutdown
);

    parameter THRESHOLD = 4'b1010; // Set threshold to 10 (in decimal)
    parameter SAFE_LEVEL = 4'b0111; // Set safe level to 7 (in decimal)

    reg state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Normal operation state
                    if (temperature > THRESHOLD) begin
                        shutdown <= 1; // Trigger shutdown
                        state <= 1;
                    end
                end
                1: begin // Shutdown state
                    if (temperature < SAFE_LEVEL) begin
                        shutdown <= 0; // Reset shutdown
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule