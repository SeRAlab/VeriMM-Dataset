module uart_tx (
    input wire clk,
    input wire [7:0] data_in,
    input wire start,
    input wire stop,
    output reg tx
);
    reg [3:0] state; // State variable for FSM
    reg [3:0] bit_index; // To track the bit being transmitted

    parameter IDLE = 4'b0000, START_BIT = 4'b0001, DATA_BITS = 4'b0010, STOP_BIT = 4'b0011;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                tx <= 1; // Idle state is high
                if (start) begin
                    state <= START_BIT; 
                    bit_index <= 0; 
                end
            end
            
            START_BIT: begin
                tx <= 0; // Start bit is low
                state <= DATA_BITS;
            end
            
            DATA_BITS: begin
                tx <= data_in[bit_index]; // Transmit data bits
                if (bit_index < 7) begin
                    bit_index <= bit_index + 1;
                end else begin
                    state <= STOP_BIT; // Move to stop bit after last data bit
                end
            end
            
            STOP_BIT: begin
                tx <= 1; // Stop bit is high
                state <= IDLE; // Return to IDLE state
            end
        endcase
    end
endmodule