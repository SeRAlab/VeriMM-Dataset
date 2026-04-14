module traffic_light_controller (
    input wire clk,
    input wire reset,
    output reg [1:0] state // 00: RED, 01: GREEN, 10: YELLOW
);

    parameter RED_DURATION = 3;   // Duration for RED
    parameter GREEN_DURATION = 2; // Duration for GREEN
    parameter YELLOW_DURATION = 1;// Duration for YELLOW

    reg [2:0] counter; // 3-bit counter
    reg [1:0] next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Start with RED
            counter <= 0;
        end else begin
            if (counter == (state == 2'b00 ? RED_DURATION : (state == 2'b01 ? GREEN_DURATION : YELLOW_DURATION))) begin
                state <= next_state; // Transition to next state
                counter <= 0; // Reset counter
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end
    end

    always @(*) begin
        case (state)
            2'b00: next_state = 2'b01; // RED to GREEN
            2'b01: next_state = 2'b10; // GREEN to YELLOW
            2'b10: next_state = 2'b00; // YELLOW to RED
            default: next_state = 2'b00; // Fallback
        endcase
    end
endmodule