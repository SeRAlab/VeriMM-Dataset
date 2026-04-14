module ethernet_mac_controller(
    input clk,
    input reset,
    input start_tx,
    input error,
    output reg [1:0] state // 00: IDLE, 01: TRANSMIT, 10: ERROR
);
    parameter IDLE = 2'b00;
    parameter TRANSMIT = 2'b01;
    parameter ERROR = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_tx) state <= TRANSMIT;
                end
                TRANSMIT: begin
                    if (error) state <= ERROR;
                    // Assume transmission ends and goes back to IDLE
                    else state <= IDLE; 
                end
                ERROR: begin
                    // Error state, awaiting reset to go back to IDLE
                    if (reset) state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule