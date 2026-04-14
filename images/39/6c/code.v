module uart_transmitter (
    input wire clk,
    input wire reset,
    input wire start_transmit,
    input wire [7:0] data_in,
    output reg tx,
    output reg done
);
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [1:0] state;
    reg [3:0] bit_index;
    reg [15:0] counter; // counter for baud rate
    parameter BAUD_RATE = 16'd104; // Example value for 9600 baud with a 1MHz clock

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1'b1; // idle state is high
            done <= 1'b0;
            bit_index <= 4'b0000;
            counter <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;  // Idle state
                    done <= 1'b0;
                    if (start_transmit) begin
                        state <= START;
                        bit_index <= 4'b0000;
                        counter <= 16'b0;
                    end
                end
                START: begin
                    if (counter < BAUD_RATE) begin
                        counter <= counter + 1;
                    end else begin
                        tx <= 1'b0; // Send start bit
                        counter <= 16'b0;
                        state <= DATA;
                    end
                end
                DATA: begin
                    if (counter < BAUD_RATE) begin
                        counter <= counter + 1;
                    end else begin
                        tx <= data_in[bit_index]; // Send data bit
                        counter <= 16'b0;
                        if (bit_index < 4'b0111) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            state <= STOP;
                        end
                    end
                end
                STOP: begin
                    if (counter < BAUD_RATE) begin
                        counter <= counter + 1;
                    end else begin
                        tx <= 1'b1; // Send stop bit
                        counter <= 16'b0;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule