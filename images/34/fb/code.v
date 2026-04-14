module sata_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire data_received,
    input wire transmit_complete,
    output reg [1:0] state // 00: Idle, 01: Ready, 10: Transmitting
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter READY = 2'b01;
    parameter TRANSMITTING = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= READY;
                    end
                end
                
                READY: begin
                    if (data_received) begin
                        state <= TRANSMITTING;
                    end
                end
                
                TRANSMITTING: begin
                    if (transmit_complete) begin
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE; // Fallback to IDLE
            endcase
        end
    end
endmodule