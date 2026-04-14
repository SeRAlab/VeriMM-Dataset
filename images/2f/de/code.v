module sata_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire stop,
    input wire error,
    output reg [1:0] state // 00: IDLE, 01: ACTIVE, 10: ERROR
);

    // State Encoding
    parameter IDLE = 2'b00;
    parameter ACTIVE = 2'b01;
    parameter ERROR = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= ACTIVE;
                ACTIVE: begin
                    if (stop) state <= IDLE;
                    if (error) state <= ERROR;
                end
                ERROR: if (reset) state <= IDLE;
            endcase
        end
    end
endmodule