module spi_master (
    input wire clk,              // System clock
    input wire reset,            // Reset signal
    input wire start,            // Start transmission signal
    input wire [7:0] data_in,    // 8-bit data input
    output reg mosi,             // Master Out Slave In
    output reg sck,              // Serial Clock
    output reg ss                // Slave Select
);

    reg [2:0] bit_count;         // Count of bits sent
    reg state;                   // State of transmission (0: idle, 1: transmitting)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mosi <= 1'b0;
            sck <= 1'b0;
            ss <= 1'b1;          // Active low
            bit_count <= 3'b000;
            state <= 1'b0;
        end else begin
            if (start && !state) begin
                ss <= 1'b0;      // Enable slave
                state <= 1'b1;   // Start transmitting
            end
            
            if (state) begin
                if (bit_count < 3'b1000) begin // 8 bits transmission
                    mosi <= data_in[7 - bit_count]; // Send MSB first
                    sck <= 1'b1; // Generate clock high
                    #1; // Wait for a moment
                    sck <= 1'b0; // Generate clock low
                    bit_count <= bit_count + 1;
                end else begin
                    ss <= 1'b1;  // Disable slave after transmission
                    state <= 1'b0; // Go back to idle state
                    bit_count <= 3'b000; // Reset bit count
                end
            end
        end
    end
endmodule