module sata_controller (
    input clk,
    input rst,
    input start,
    input error,
    output reg [1:0] state // 00: IDLE, 01: TRANSFER, 10: ERROR
);
    
    // State encoding
    parameter IDLE = 2'b00, TRANSFER = 2'b01, ERROR = 2'b10;

    // State transition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSFER;
                    end
                end
                TRANSFER: begin
                    if (error) begin
                        state <= ERROR;
                    end else begin
                        // continue transferring
                        state <= TRANSFER;
                    end
                end
                ERROR: begin
                    if (~error) begin
                        state <= IDLE; // return to IDLE after error is cleared
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule