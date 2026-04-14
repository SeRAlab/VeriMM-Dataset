module arq_system (
    input wire clk,
    input wire rst,
    input wire data_in,
    output reg ack,
    output reg nack,
    output reg parity_bit
);

reg [1:0] state;
parameter IDLE = 2'b00, SEND = 2'b01, WAIT_ACK = 2'b10;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        ack <= 0;
        nack <= 0;
        parity_bit <= 0;
    end else begin
        case (state)
            IDLE: begin
                // Prepare to send data
                parity_bit <= data_in ^ 1; // Simple parity generation
                state <= SEND;
            end
            SEND: begin
                // Send data and wait for ACK/NACK
                state <= WAIT_ACK;
            end
            WAIT_ACK: begin
                if (parity_bit == 1) begin
                    ack <= 1; // Simulate ACK reception
                    nack <= 0; 
                end else begin
                    nack <= 1; // Simulate NACK reception
                    ack <= 0;
                end
                state <= IDLE; // Go back to idle
            end
        endcase
    end
end

endmodule