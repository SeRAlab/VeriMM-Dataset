module uart_transmitter (
    input wire clk,
    input wire start,
    input wire [7:0] data,
    output reg tx,
    output reg busy
);
    reg [3:0] state;
    reg [3:0] bit_index;
    
    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;
    
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (start) begin
                    busy <= 1;
                    tx <= 0; // Start bit
                    state <= START;
                    bit_index <= 0;
                end
            end
            START: begin
                state <= DATA;
            end
            DATA: begin
                tx <= data[bit_index];
                if (bit_index < 7) begin
                    bit_index <= bit_index + 1;
                end else begin
                    state <= STOP;
                end
            end
            STOP: begin
                tx <= 1; // Stop bit
                busy <= 0;
                state <= IDLE;
            end
        endcase
    end
endmodule