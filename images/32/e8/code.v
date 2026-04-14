module uart_transmitter(
    input clk,
    input rst,
    input tx_en,
    input [7:0] data_in,
    output reg tx
);
    reg [3:0] state;
    reg [3:0] count;
    reg [7:0] data;
    
    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1; // idle state of UART is high
            count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (tx_en) begin
                        state <= START;
                        data <= data_in;
                        count <= 0;
                    end
                end
                START: begin
                    tx <= 0; // start bit
                    state <= DATA;
                end
                DATA: begin
                    tx <= data[count]; // transmit data bit
                    if (count < 7) begin
                        count <= count + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    tx <= 1; // stop bit
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule