module uart_tx (
    input clk,
    input reset,
    input start_tx,
    input [7:0] data_in,
    output reg tx
);
    reg [3:0] bit_count;
    reg [9:0] shift_reg; // 1 Start bit + 8 Data bits + 1 Stop bit
    reg transmitting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1; // Idle state
            bit_count <= 0;
            transmitting <= 0;
        end else if (start_tx && !transmitting) begin
            shift_reg <= {1'b1, data_in, 1'b0}; // Load the shift register with Stop bit, Data, Start bit
            bit_count <= 0;
            transmitting <= 1;
        end else if (transmitting) begin
            tx <= shift_reg[0]; // Output the current bit
            shift_reg <= {1'b1, shift_reg[9:1]}; // Shift right
            bit_count <= bit_count + 1;

            if (bit_count == 9) begin // After sending 10 bits (1 Start, 8 Data, 1 Stop)
                transmitting <= 0; // Stop transmitting
            end
        end
    end
endmodule