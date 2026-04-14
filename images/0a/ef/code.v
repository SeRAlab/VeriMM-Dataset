module sata_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire busy,
    output reg [1:0] state // 00: IDLE, 01: TRANSFER, 10: DONE
);
    
    // State encoding
    parameter IDLE = 2'b00;
    parameter TRANSFER = 2'b01;
    parameter DONE = 2'b10;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= TRANSFER;
                TRANSFER: if (!busy) state <= DONE;
                DONE: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule