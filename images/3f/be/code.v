module sata_controller(
    input clk,
    input reset,
    input start_transmission,
    input complete_transmission,
    input error_detected,
    output reg [1:0] current_state
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter ACTIVE = 2'b01;
    parameter ERROR = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else begin
            case (current_state)
                IDLE: begin
                    if (start_transmission)
                        current_state <= ACTIVE;
                end
                ACTIVE: begin
                    if (complete_transmission)
                        current_state <= IDLE;
                    else if (error_detected)
                        current_state <= ERROR;
                end
                ERROR: begin
                    if (reset)
                        current_state <= IDLE; // Reset to IDLE on error recovery
                end
                default: current_state <= IDLE; // Default case
            endcase
        end
    end
endmodule