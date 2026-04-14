module ARQ (
    input clk,
    input reset,
    input [7:0] data_in,        // Data input
    input ack,                  // Acknowledgment signal
    output reg [7:0] data_out,  // Data output
    output reg [1:0] state      // State of the system
);

    reg [1:0] packet_counter;    // To keep track of sent packets
    parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10, RETRANSMIT = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            packet_counter <= 0;
            data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (packet_counter < 4) begin
                        data_out <= data_in; // Send data
                        packet_counter <= packet_counter + 1;
                        state <= SEND;
                    end
                end
                
                SEND: begin
                    state <= WAIT_ACK;  // Move to wait for acknowledgment
                end

                WAIT_ACK: begin
                    if (ack) begin
                        state <= IDLE; // If ack received, go back to idle
                    end else begin
                        state <= RETRANSMIT; // If no ack, retransmit
                    end
                end

                RETRANSMIT: begin
                    data_out <= data_in; // Retransmit data
                    state <= WAIT_ACK; // Wait for acknowledgment again
                end
            endcase
        end
    end
endmodule