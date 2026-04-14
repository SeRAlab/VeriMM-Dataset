module I2C_Controller(
    input wire clk,
    input wire reset,
    input wire data_in,
    output reg data_out,
    output reg [1:0] state // 00: idle, 01: transmitting, 10: receiving
);

    parameter IDLE = 2'b00;
    parameter TRANSMITTING = 2'b01;
    parameter RECEIVING = 2'b10;

    reg [1:0] next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    next_state = TRANSMITTING;
                end else begin
                    next_state = IDLE;
                end
            end
            TRANSMITTING: begin
                data_out = data_in; // Transmit data
                next_state = RECEIVING;
            end
            RECEIVING: begin
                data_out = 1'bz; // High-Z while receiving
                next_state = IDLE; // Go back to idle after receiving
            end
            default: next_state = IDLE;
        endcase
    end

endmodule