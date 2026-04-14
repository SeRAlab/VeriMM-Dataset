module ethernet_mac(
    input clk,
    input reset,
    input [7:0] data_in,
    input valid_in,
    output reg [7:0] data_out,
    output reg valid_out,
    output reg tx_busy,
    output reg rx_ready
);
    reg [1:0] state;
    reg [7:0] fifo [0:15]; // Simple FIFO buffer
    reg [3:0] fifo_count;

    parameter IDLE = 2'b00, TRANSMITTING = 2'b01, RECEIVING = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            fifo_count <= 0;
            data_out <= 0;
            valid_out <= 0;
            tx_busy <= 0;
            rx_ready <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (valid_in) begin
                        fifo[fifo_count] <= data_in;
                        fifo_count <= fifo_count + 1;
                        tx_busy <= 1;
                        state <= TRANSMITTING;
                    end
                end
                TRANSMITTING: begin
                    if (fifo_count > 0) begin
                        data_out <= fifo[0];
                        valid_out <= 1;
                        fifo_count <= fifo_count - 1;
                        tx_busy <= (fifo_count > 1) ? 1 : 0;
                    end else begin
                        valid_out <= 0;
                        state <= IDLE;
                    end
                end
                RECEIVING: begin
                    // Placeholder for receiving logic
                end
            endcase
        end
    end
endmodule