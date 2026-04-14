module spi_master (
    input wire clk,
    input wire start,
    input wire [7:0] data_in,
    output reg mosi,
    output reg sclk,
    output reg ss
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg state;

    always @(posedge clk) begin
        if (start) begin
            ss <= 0;                  // Activate Slave Select
            shift_reg <= data_in;     // Load data into shift register
            bit_count <= 7;           // Start from MSB
            state <= 1;               // Set state to transmitting
        end else if (state) begin
            if (bit_count >= 0) begin
                sclk <= 1;            // Generate clock signal
                mosi <= shift_reg[bit_count]; // Send MSB first
                bit_count <= bit_count - 1;
            end else begin
                sclk <= 0;            // Stop clock signal
                ss <= 1;              // Deactivate Slave Select
                state <= 0;           // End transmission
            end
        end else begin
            sclk <= 0;                // Ensure clock is low when not transmitting
        end
    end
endmodule