module deserializer (
    input wire clk,
    input wire reset,
    input wire [7:0] parallel_in,
    output reg [15:0] serial_out,
    output reg valid
);
    reg [1:0] state; // State: 0 - idle, 1 - first part, 2 - second part

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            serial_out <= 16'b0;
            valid <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    // Idle state, wait for input
                    if (parallel_in !== 8'bx) begin
                        serial_out[15:8] <= parallel_in; // First 8 bits
                        state <= 1;
                    end
                end
                1: begin
                    serial_out[7:0] <= parallel_in; // Last 8 bits
                    valid <= 1;
                    state <= 2;
                end
                2: begin
                    valid <= 0; // Reset valid after output
                    state <= 0; // Go back to idle
                end
            endcase
        end
    end
endmodule