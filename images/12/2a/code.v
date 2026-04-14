module deadbeat_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] setpoint,
    input wire [7:0] current_value,
    output reg [7:0] control_signal
);

reg [7:0] error;
reg [2:0] state; // 3-bit state for controlling the number of steps
parameter IDLE = 3'b000, STEP1 = 3'b001, STEP2 = 3'b010, STEP3 = 3'b011, DONE = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        control_signal <= 8'b0;
        error <= 8'b0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                error <= setpoint - current_value;
                control_signal <= error; // Initial control signal
                state <= STEP1;
            end
            STEP1: begin
                control_signal <= control_signal - (error >> 1); // Adjust control signal
                state <= STEP2;
            end
            STEP2: begin
                control_signal <= control_signal - (error >> 2); // Further adjust
                state <= STEP3;
            end
            STEP3: begin
                control_signal <= control_signal; // Final adjustment
                state <= DONE;
            end
            DONE: begin
                // Controller has reached steady state
                control_signal <= control_signal;
            end
        endcase
    end
end

endmodule