module i2c_master(
    input wire clk,
    input wire start,
    input wire [7:0] data_in,
    output reg SDA,
    output reg SCL,
    output reg ack
);
    reg [3:0] state; // State machine state
    reg [3:0] bit_cnt; // Bit counter
    reg [7:0] data_reg; // Register to hold the data

    localparam IDLE = 0, START = 1, TRANSMIT = 2, STOP = 3;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                SDA <= 1; // Idle state SDA high
                SCL <= 1; // Idle state SCL high
                ack <= 0; // No acknowledge initially
                if (start) begin
                    data_reg <= data_in; // Load data
                    state <= START; // Move to START state
                end
            end
            START: begin
                SDA <= 0; // Start condition
                SCL <= 1; // Keep SCL high
                state <= TRANSMIT; // Move to TRANSMIT state
                bit_cnt <= 0; // Reset bit counter
            end
            TRANSMIT: begin
                if (bit_cnt < 8) begin
                    SCL <= 0; // SCL low for data transmission
                    SDA <= data_reg[7 - bit_cnt]; // Transmit bit
                    bit_cnt <= bit_cnt + 1; // Increment bit counter
                    SCL <= 1; // SCL high for acknowledge
                end else begin
                    ack <= 1; // Data transmitted, set acknowledge
                    state <= STOP; // Move to STOP state
                end
            end
            STOP: begin
                SDA <= 0; // SDA low to begin stop condition
                SCL <= 1; // SCL high
                SDA <= 1; // SDA high to finish stop condition
                state <= IDLE; // Return to IDLE state
            end
        endcase
    end
endmodule