module pcie_endpoint_controller (
    input clk,
    input reset,
    input start_config,
    input start_data,
    input error,
    output reg [1:0] state // 00: IDLE, 01: CONFIG, 10: DATA_TRANSFER, 11: ERROR
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter CONFIG = 2'b01;
    parameter DATA_TRANSFER = 2'b10;
    parameter ERROR = 2'b11;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset state to IDLE
        end else begin
            case (state)
                IDLE: begin
                    if (start_config) state <= CONFIG;
                end
                
                CONFIG: begin
                    if (start_data) state <= DATA_TRANSFER;
                    else if (error) state <= ERROR;
                end
                
                DATA_TRANSFER: begin
                    if (error) state <= ERROR;
                end
                
                ERROR: begin
                    if (reset) state <= IDLE; // Go back to IDLE on reset
                end
            
                default: state <= IDLE; // Default case
            endcase
        end
    end
endmodule