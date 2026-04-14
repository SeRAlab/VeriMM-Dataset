module spi_master (
    input wire clk,              // System clock
    input wire reset,            // Active high reset
    input wire start,            // Start communication
    input wire [7:0] tx_data,    // Data to be transmitted
    input wire cpol,             // Clock polarity
    input wire cpha,             // Clock phase
    output reg miso,             // Master In Slave Out
    output reg mosi,             // Master Out Slave In
    output reg sclk,             // Serial clock
    output reg cs_n,             // Chip select (active low)
    output reg busy,             // Indicates the controller is busy
    output reg [7:0] rx_data     // Data received from slave
);

    reg [2:0] state;            // State machine
    reg [2:0] bit_count;        // Bit counter for transmission
    reg [7:0] shift_reg;        // Shift register for transmission/receiving

    localparam IDLE = 3'b000, 
               START = 3'b001, 
               TRANSFER = 3'b010, 
               STOP = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            busy <= 0;
            cs_n <= 1; // CS is high (inactive)
            sclk <= 0;
            bit_count <= 0;
            rx_data <= 0;
            mosi <= 0;
            miso <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        cs_n <= 0; // Activate chip select
                        shift_reg <= tx_data; // Load data to send
                        bit_count <= 0; // Reset bit counter
                        state <= START;
                        busy <= 1;
                    end
                end
                
                START: begin
                    if (cpha == 0) sclk <= 1; // Set clock high
                    state <= TRANSFER; // Move to transfer state
                end

                TRANSFER: begin
                    if (bit_count < 8) begin
                        sclk <= ~sclk; // Toggle clock
                        if (sclk) begin // On rising edge
                            mosi <= shift_reg[7]; // Send MSB
                            miso <= 0; // Assuming slave drives miso
                            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                            bit_count <= bit_count + 1; // Increment bit count
                        end else begin // On falling edge
                            rx_data <= {rx_data[6:0], miso}; // Receive data
                        end
                    end else begin
                        state <= STOP; // Move to stop state after 8 bits
                    end
                end
                
                STOP: begin
                    cs_n <= 1; // Deactivate chip select
                    busy <= 0;
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule