module state_space_controller (
    input wire clk,
    input wire reset,
    input wire [1:0] input_signal,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter PROCESSING = 2'b01;
    parameter COMPLETE = 2'b10;
    parameter ERROR = 2'b11;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset to IDLE state
        end else begin
            case (state)
                IDLE: begin
                    if (input_signal == 2'b01)
                        state <= PROCESSING;
                end
                PROCESSING: begin
                    if (input_signal == 2'b10)
                        state <= COMPLETE;
                end
                COMPLETE: begin
                    if (input_signal == 2'b11)
                        state <= ERROR;
                end
                ERROR: begin
                    if (input_signal == 2'b00)
                        state <= IDLE;
                end
                default: state <= state; // Remain in the same state
            endcase
        end
    end
endmodule