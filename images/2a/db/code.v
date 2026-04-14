module i2c_master (
    input wire clk,               // System clock
    input wire start,             // Signal to start the I2C transfer
    input wire [7:0] data,        // Data to send
    output reg scl,               // I2C clock line
    output reg sda                // I2C data line
);
    reg [3:0] state;              // State register
    reg [3:0] bit_cnt;            // Bit counter

    // State encoding
    localparam IDLE      = 4'b0000;
    localparam START     = 4'b0001;
    localparam SEND_BYTE  = 4'b0010;
    localparam STOP      = 4'b0011;

    // I2C clock generation
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                scl <= 1;
                sda <= 1; // SDA high in idle state
                if (start) begin
                    state <= START;
                end
            end
            START: begin
                sda <= 0; // Start condition
                scl <= 1;
                state <= SEND_BYTE;
                bit_cnt <= 0;
            end
            SEND_BYTE: begin
                if (bit_cnt < 8) begin
                    sda <= data[7 - bit_cnt]; // Send MSB first
                    scl <= 0; // Pull SCL low
                    scl <= 1; // SCL high, data is valid
                    bit_cnt <= bit_cnt + 1;
                end else begin
                    state <= STOP; // Finished sending byte
                end
            end
            STOP: begin
                sda <= 0; // Pull SDA low
                scl <= 1; // Pull SCL high during stop
                sda <= 1; // Stop condition
                state <= IDLE; // Return to idle state
            end
        endcase
    end
endmodule