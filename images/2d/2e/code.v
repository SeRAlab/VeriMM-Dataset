module uart_transmitter (
    input wire clk,
    input wire enable,
    input wire [7:0] data_in,
    output reg tx
);
  
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000; // Assume system clock is 50 MHz
    localparam BIT_PERIOD = CLOCK_FREQ / BAUD_RATE; // Number of clock cycles per bit
    
    reg [3:0] state;
    reg [13:0] bit_counter; // To count clock cycles
    reg [3:0] bit_index; // Index to track the bit being sent
    reg [9:0] shift_reg; // To include start and stop bits
    
    localparam IDLE = 4'd0;
    localparam START_BIT = 4'd1;
    localparam DATA_BITS = 4'd2;
    localparam STOP_BIT = 4'd3;
    
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                tx <= 1; // Idle state is high
                if (enable) begin
                    shift_reg <= {1'b1, data_in, 1'b0}; // Start with stop bit, data, start bit
                    bit_index <= 0;
                    bit_counter <= 0;
                    state <= START_BIT;
                end
            end
            
            START_BIT: begin
                tx <= 0; // Send start bit
                if (bit_counter < BIT_PERIOD - 1) begin
                    bit_counter <= bit_counter + 1;
                end else begin
                    bit_counter <= 0;
                    state <= DATA_BITS;
                end
            end
            
            DATA_BITS: begin
                tx <= shift_reg[bit_index]; // Send current bit
                if (bit_counter < BIT_PERIOD - 1) begin
                    bit_counter <= bit_counter + 1;
                end else begin
                    bit_counter <= 0;
                    bit_index <= bit_index + 1;
                    if (bit_index == 8) begin
                        state <= STOP_BIT;
                    end
                end
            end
            
            STOP_BIT: begin
                tx <= 1; // Send stop bit
                if (bit_counter < BIT_PERIOD - 1) begin
                    bit_counter <= bit_counter + 1;
                end else begin
                    bit_counter <= 0;
                    state <= IDLE; // Go back to IDLE
                end
            end
            
            default: state <= IDLE;
        endcase
    end
endmodule