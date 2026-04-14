module ARQ_System (
    input clk,
    input rst,
    input [4:0] data_in,
    input ack,
    output reg [4:0] data_out,
    output reg retransmit,
    output reg done
);
    reg [1:0] state;
    reg [1:0] retransmission_count;

    localparam IDLE = 2'b00, TRANSMIT = 2'b01, WAIT_ACK = 2'b10, DONE = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            retransmission_count <= 2'b00;
            retransmit <= 1'b0;
            done <= 1'b0;
            data_out <= 5'b00000;
        end else begin
            case (state)
                IDLE: begin
                    data_out <= data_in;
                    retransmit <= 1'b0;
                    retransmission_count <= 2'b00;
                    state <= TRANSMIT;
                end

                TRANSMIT: begin
                    retransmit <= 1'b1;
                    state <= WAIT_ACK;
                end

                WAIT_ACK: begin
                    if (ack) begin
                        done <= 1'b1;
                        state <= DONE;
                    end else if (retransmission_count < 2'b11) begin
                        retransmission_count <= retransmission_count + 1;
                        state <= TRANSMIT;
                    end else begin
                        done <= 1'b0;
                        state <= DONE;
                    end
                end

                DONE: begin
                    retransmit <= 1'b0;
                    if (!ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule