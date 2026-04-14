module deadbeat_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [3:0] error,
    output reg control_signal
);

    reg [1:0] state;
    parameter IDLE = 2'b00;
    parameter ACTIVE = 2'b01;
    parameter HOLD = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            control_signal <= 1'b0;
        end else if (!enable) begin
            control_signal <= control_signal; // Hold the output
            state <= HOLD;
        end else begin
            case (state)
                IDLE: begin
                    if (error != 4'b0000) begin
                        control_signal <= 1'b0; // Start control action
                        state <= ACTIVE;
                    end
                end
                ACTIVE: begin
                    if (error == 4'b0000) begin
                        control_signal <= 1'b0; // Output remains low
                        state <= IDLE;
                    end else begin
                        control_signal <= 1'b1; // Output high to correct error
                        state <= IDLE; // Transition back to idle after one cycle
                    end
                end
                HOLD: begin
                    // Hold state, do nothing
                    state <= HOLD;
                end
            endcase
        end
    end
endmodule