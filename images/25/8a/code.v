module stop_and_wait (
    input clk,
    input rst,
    input [7:0] data_in,
    input send,
    output reg ack,
    output reg sending,
    output reg [7:0] data_out
);
    reg [1:0] state;
    
    localparam IDLE = 2'b00,
               SEND = 2'b01,
               WAIT_ACK = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ack <= 0;
            sending <= 0;
            data_out <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (send) begin
                        data_out <= data_in;
                        sending <= 1;
                        state <= SEND;
                    end
                end
                SEND: begin
                    // Simulate sending data and waiting for ack
                    sending <= 0;
                    state <= WAIT_ACK;
                end
                WAIT_ACK: begin
                    // Simulate receiving ack
                    ack <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule