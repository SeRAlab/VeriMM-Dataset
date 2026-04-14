module ARQ_System (
    input wire clk,
    input wire rst,
    input wire [4:0] data_in,
    input wire ack,
    output reg [4:0] data_out,
    output reg [1:0] state // 00: IDLE, 01: SENDING, 10: WAIT_ACK, 11: ERROR
);
    reg [1:0] attempt;

    // State encoding
    localparam IDLE = 2'b00, 
               SENDING = 2'b01, 
               WAIT_ACK = 2'b10, 
               ERROR = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            attempt <= 2'b00;
            data_out <= 5'b00000;
        end else begin
            case (state)
                IDLE: begin
                    data_out <= data_in; // Load data to send
                    state <= SENDING; // Move to sending state
                    attempt <= 2'b00; // Reset attempts
                end
                SENDING: begin
                    state <= WAIT_ACK; // Move to wait for ACK
                end
                WAIT_ACK: begin
                    if (ack) begin
                        state <= IDLE; // ACK received, go back to IDLE
                    end else begin
                        attempt <= attempt + 1; // Increment attempt
                        if (attempt >= 2'b10) begin
                            state <= ERROR; // Maximum attempts reached
                        end else begin
                            state <= SENDING; // Resend data
                        end
                    end
                end
                ERROR: begin
                    // Handle error state (can be expanded for logging, etc.)
                    data_out <= 5'b11111; // Indicate error in output
                end
                default: state <= IDLE; // Default to IDLE
            endcase
        end
    end
endmodule