module traffic_light_controller (
    input clk,
    input reset,
    output reg [1:0] state // 00: RED, 01: GREEN, 10: YELLOW
);
    reg [2:0] timer; // 3-bit timer for counting time units
    reg [1:0] next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Start from RED state
            timer <= 3'b000;
        end else begin
            // Update state based on timer
            if (timer == 3'b111) begin // Timer expires
                state <= next_state;
                timer <= 3'b000; // Reset timer
            end else begin
                timer <= timer + 1; // Increment timer
            end
        end
    end

    always @(*) begin
        case (state)
            2'b00: next_state = 2'b01; // RED to GREEN
            2'b01: next_state = 2'b10; // GREEN to YELLOW
            2'b10: next_state = 2'b00; // YELLOW to RED
            default: next_state = 2'b00; // Default to RED
        endcase
    end
endmodule