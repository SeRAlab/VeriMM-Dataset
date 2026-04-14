module uart_transmitter (
    input wire clk,
    input wire start,
    input wire [7:0] data,
    output reg tx
);
    reg [3:0] state;
    reg [3:0] count;
    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                tx <= 1; // idle state is high
                if (start) begin
                    state <= START;
                    count <= 0;
                end
            end

            START: begin
                tx <= 0; // start bit
                state <= DATA;
                count <= 0;
            end

            DATA: begin
                tx <= data[count]; // transmit data bits
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
endmodule