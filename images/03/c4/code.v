module i2c_master (
    input wire clk,               // System clock
    input wire reset,             // Active high reset
    input wire start,             // Start signal to initiate communication
    input wire [7:0] data_in,     // Data byte to send
    output reg sda,               // Serial Data Line
    output reg scl,               // Serial Clock Line
    output reg ack                // Acknowledge signal from slave
);
    reg [3:0] state;              // State variable for FSM
    reg [3:0] bit_cnt;            // Bit counter for sending data

    // State encoding
    localparam IDLE = 4'b0000,
               START = 4'b0001,
               SEND_DATA = 4'b0010,
               ACK_CHECK = 4'b0011,
               STOP = 4'b0100;

    // Main FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            sda <= 1;
            scl <= 1;
            ack <= 0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= START;
                        sda <= 0; // Start condition
                        scl <= 1;
                        bit_cnt <= 0;
                    end
                end
                START: begin
                    scl <= 0; // Pull SCL low
                    state <= SEND_DATA;
                end
                SEND_DATA: begin
                    sda <= data_in[7 - bit_cnt]; // Send MSB first
                    scl <= 1; // Clock high to send bit
                    state <= (bit_cnt == 7) ? ACK_CHECK : SEND_DATA;
                    if (bit_cnt < 8) bit_cnt <= bit_cnt + 1;
                end
                ACK_CHECK: begin
                    scl <= 0;
                    // Assume a valid ACK is received (for simulation purposes)
                    ack <= 1; // Set ACK high if slave acknowledged
                    state <= STOP;
                end
                STOP: begin
                    sda <= 1; // Stop condition
                    state <= IDLE; // Return to idle
                end
            endcase
        end
    end
endmodule