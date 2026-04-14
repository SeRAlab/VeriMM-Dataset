module uart_receiver(
    input wire rx,
    input wire clk,
    input wire rst,
    output reg [7:0] data_out,
    output reg data_valid
);
    reg [3:0] state;
    reg [3:0] bit_counter;
    reg [7:0] shift_reg;

    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            bit_counter <= 0;
            data_valid <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (rx == 0) begin // Start bit detected
                        state <= START;
                        bit_counter <= 0;
                    end
                end
                START: begin
                    state <= DATA; // Move to DATA state once start bit is detected
                end
                DATA: begin
                    shift_reg[bit_counter] <= rx;
                    if (bit_counter < 7) begin
                        bit_counter <= bit_counter + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    data_out <= shift_reg; // Output the received byte
                    data_valid <= 1; // Indicate valid data
                    state <= IDLE; // Return to IDLE state
                end
            endcase
        end
    end
endmodule