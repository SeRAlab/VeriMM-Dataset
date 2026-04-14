module uart_receiver (
    input wire clk,
    input wire rst,
    input wire serial_in,
    output reg [7:0] data_out,
    output reg data_ready
);
    reg [3:0] bit_count;
    reg [7:0] buffer;
    reg state; // 0: idle, 1: receiving

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            bit_count <= 0;
            buffer <= 0;
            data_out <= 0;
            data_ready <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    data_ready <= 0;
                    if (serial_in == 0) begin // Start bit detected
                        state <= 1;
                        bit_count <= 0;
                    end
                end
                1: begin // Receiving state
                    if (bit_count < 8) begin
                        buffer[bit_count] <= serial_in; // Shift in data
                        bit_count <= bit_count + 1;
                    end else begin
                        data_out <= buffer; // Load received data
                        data_ready <= 1;
                        state <= 0; // Return to idle
                    end
                end
            endcase
        end
    end
endmodule