module uart_transmitter(
    input wire clk,
    input wire transmit_en,
    input wire [7:0] data_in,
    output reg tx,
    output reg ready
);
    reg [3:0] state;
    reg [2:0] bit_index;
    
    localparam WAIT = 4'b0000,
               START = 4'b0001,
               DATA = 4'b0010,
               STOP = 4'b0011;

    always @(posedge clk) begin
        case(state)
            WAIT: begin
                tx <= 1; // idle state
                ready <= 1; // ready to transmit
                if (transmit_en) begin
                    state <= START;
                    bit_index <= 0;
                    ready <= 0; // not ready while transmitting
                end
            end
            
            START: begin
                tx <= 0; // start bit
                state <= DATA;
            end
            
            DATA: begin
                tx <= data_in[bit_index]; // transmit data bit
                if (bit_index < 7) begin
                    bit_index <= bit_index + 1;
                end else begin
                    state <= STOP;
                end
            end
            
            STOP: begin
                tx <= 1; // stop bit
                state <= WAIT; // return to wait state
            end
            
            default: state <= WAIT;
        endcase
    end
endmodule