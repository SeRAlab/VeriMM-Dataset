module arq_protocol(
    input wire clk,
    input wire enable,
    input wire [7:0] data_in,
    output reg ack,
    output reg resend
);
    reg [3:0] state;
    parameter IDLE = 4'b0000, SEND = 4'b0001, WAIT_ACK = 4'b0010, RESEND = 4'b0011;

    always @(posedge clk) begin
        if (enable) begin
            case (state)
                IDLE: begin
                    ack <= 0;
                    resend <= 0;
                    state <= SEND;
                end
                SEND: begin
                    // Simulate sending data
                    // Here data_in would be sent
                    state <= WAIT_ACK;
                end
                WAIT_ACK: begin
                    // Assume we're waiting for an ack signal
                    // For simulation, let's toggle ack after some cycles
                    ack <= 1; // Simulate receiving an ack
                    state <= IDLE; // go back to IDLE
                end
                default: begin
                    resend <= 1; // If no ack is received
                    state <= RESEND;
                end
            endcase
        end
    end
endmodule