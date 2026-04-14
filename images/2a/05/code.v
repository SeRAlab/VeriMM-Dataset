module deadbeat_controller(
    input clk,
    input reset,
    input [3:0] setpoint,
    input [3:0] current_value,
    output reg [3:0] control_signal
);
    reg [3:0] error;
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 4'b0000;
            state <= 2'b00;
        end else begin
            error <= setpoint - current_value;
            case (state)
                2'b00: begin
                    control_signal <= error; // First cycle
                    state <= 2'b01;
                end
                2'b01: begin
                    control_signal <= error; // Second cycle
                    state <= 2'b10;
                end
                2'b10: begin
                    control_signal <= error; // Third cycle
                    state <= 2'b11;
                end
                2'b11: begin
                    control_signal <= error; // Fourth cycle
                    state <= 2'b00; // Reset to first cycle
                end
            endcase
        end
    end
endmodule