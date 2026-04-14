module ARQ_Protocol (
    input wire clk,
    input wire reset,
    input wire data_valid,
    input wire [7:0] data_in,
    input wire parity_check,
    output reg send,
    output reg [7:0] data_out,
    output reg request_retransmit
);
    reg [1:0] state;
    
    localparam IDLE = 2'd0,
               SEND = 2'd1,
               WAIT = 2'd2,
               RETRANSMIT = 2'd3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            send <= 0;
            request_retransmit <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_valid) begin
                        state <= SEND;
                    end
                end

                SEND: begin
                    data_out <= data_in;
                    send <= 1;
                    if (parity_check) begin
                        state <= WAIT;
                    end else begin
                        request_retransmit <= 1;
                        state <= RETRANSMIT;
                    end
                end

                WAIT: begin
                    send <= 0;
                    if (request_retransmit) begin
                        state <= RETRANSMIT;
                    end else begin
                        state <= IDLE;
                    end
                end

                RETRANSMIT: begin
                    send <= 1;
                    request_retransmit <= 0;
                    state <= SEND; // Go back to SEND after requesting retransmit
                end
            endcase
        end
    end
endmodule