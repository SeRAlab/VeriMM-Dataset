module sata_controller (
    input clk,
    input reset,
    input send_request,
    input receive_request,
    input ack,
    output reg [1:0] state // 00: idle, 01: sending, 10: receiving
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam SENDING = 2'b01;
    localparam RECEIVING = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (send_request) 
                        state <= SENDING;
                    else if (receive_request) 
                        state <= RECEIVING;
                end
                SENDING: begin
                    if (ack)
                        state <= IDLE;
                end
                RECEIVING: begin
                    if (ack)
                        state <= IDLE;
                end
            endcase
        end
    end
endmodule