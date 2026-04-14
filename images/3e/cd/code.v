module sata_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire error,
    output reg [1:0] state // 00: IDLE, 01: TRANSFER, 10: ERROR
);

    // State Encoding
    parameter IDLE = 2'b00;
    parameter TRANSFER = 2'b01;
    parameter ERROR = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
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
                    end
                end
                ERROR: begin
                    state <= IDLE; // returns to IDLE after handling error
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule