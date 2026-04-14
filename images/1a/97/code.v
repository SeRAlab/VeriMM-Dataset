module uart_transmitter (
    input wire clk,
    input wire reset,
    input wire start, // signal to start transmission
    input wire [7:0] data_in, // 8-bit data input
    output reg tx, // serial output
    output reg busy // indicates if transmission is in progress
);

    reg [3:0] bit_index; // to keep track of the current bit being transmitted
    reg [1:0] state; // state of the FSM
    
    localparam IDLE = 2'b00,
               START_BIT = 2'b01,
               DATA_BITS = 2'b10,
               STOP_BIT = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1; // idle state is high
            busy <= 0;
            state <= IDLE;
            bit_index <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1; // idle state
                    busy <= 0;
                    if (start) begin
                        busy <= 1;
                        state <= START_BIT;
                        bit_index <= 0;
                    end
                end
                START_BIT: begin
                    tx <= 0; // start bit
                    state <= DATA_BITS;
                end
                DATA_BITS: begin
                    tx <= data_in[bit_index]; // transmit data bit
                    if (bit_index < 7) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        state <= STOP_BIT;
                    end
                end
                STOP_BIT: begin
                    tx <= 1; // stop bit
                    busy <= 0;
                    state <= IDLE; // go back to idle state
                end
            endcase
        end
    end
endmodule