module sata_controller (
    input wire clk,
    input wire reset,
    input wire send_data,
    input wire receive_data,
    output reg [1:0] state // 00: IDLE, 01: SEND, 10: RECEIVE
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter SEND = 2'b01;
    parameter RECEIVE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (send_data) begin
                        state <= SEND;
                    end else if (receive_data) begin
                        state <= RECEIVE;
                    end
                end
                SEND: begin
                    state <= IDLE; // Return to IDLE after sending
                end
                RECEIVE: begin
                    state <= IDLE; // Return to IDLE after receiving
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule