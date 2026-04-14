module ARQ_System(
    input wire clk,
    input wire rst,
    input wire send,
    input wire ack,
    output reg retransmit,
    output reg [2:0] packet_id
);
    reg [2:0] state;
    localparam IDLE = 3'b000,
               SEND = 3'b001,
               WAIT_ACK = 3'b010,
               RETRANSMIT = 3'b011,
               SUCCESS = 3'b100;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            packet_id <= 3'b000;
            retransmit <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send) begin
                        packet_id <= packet_id + 1;
                        state <= SEND;
                    end
                end
                SEND: begin
                    retransmit <= 0;
                    state <= WAIT_ACK;
                end
                WAIT_ACK: begin
                    if (ack) begin
                        state <= SUCCESS;
                    end else begin
                        state <= RETRANSMIT;
                    end
                end
                RETRANSMIT: begin
                    retransmit <= 1;
                    state <= SEND;
                end
                SUCCESS: begin
                    retransmit <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule