module uart_transmitter (
    input clk,
    input rst,
    input [7:0] data_in,
    input transmit_en,
    output reg tx,
    output reg busy
);

    reg [3:0] bit_count;  // Counts the number of bits sent
    reg [7:0] shift_reg;  // Holds the data to be sent

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;  // Idle state
            busy <= 1'b0;
            bit_count <= 4'd0;
            shift_reg <= 8'd0;
        end else if (transmit_en && !busy) begin
            busy <= 1'b1;
            shift_reg <= data_in;
            bit_count <= 4'd0;
            tx <= 1'b0;  // Start bit
        end else if (busy) begin
            if (bit_count < 8) begin
                tx <= shift_reg[bit_count];  // Transmit data bits
                bit_count <= bit_count + 1;
            end else if (bit_count == 8) begin
                tx <= 1'b1;  // Stop bit
                bit_count <= bit_count + 1;
            end else begin
                busy <= 1'b0;  // Transmission complete
            end
        end
    end
endmodule