module sata_controller (
    input clk,
    input reset,
    input start,
    input stop,
    input error,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter ACTIVE = 2'b01;
    parameter ERROR = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= ACTIVE;
                end
                ACTIVE: begin
                    if (stop) state <= IDLE;
                    else if (error) state <= ERROR;
                end
                ERROR: begin
                    if (stop) state <= IDLE; // Reset state on stop
                end
                default: state <= IDLE; // Default to IDLE
            endcase
        end
    end
endmodule