module spi_controller (
    input clk,
    input reset,
    input [7:0] data_in,
    input ss,
    output reg mosi,
    output reg transmission_complete,
    output reg [7:0] data_out
);
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mosi <= 1'b0;
            transmission_complete <= 1'b0;
            bit_cnt <= 3'b000;
            data_out <= 8'b00000000;
            shift_reg <= 8'b00000000;
        end else if (!ss) begin
            if (bit_cnt < 3'b111) begin
                mosi <= data_in[7 - bit_cnt]; // Send MSB first
                shift_reg[7 - bit_cnt] <= mosi; // Capture incoming data
                bit_cnt <= bit_cnt + 1;
            end else begin
                transmission_complete <= 1'b1; // Indicate transmission is complete
                data_out <= shift_reg; // Output the received data
                bit_cnt <= 3'b000; // Reset the bit counter for the next transmission
            end
        end else begin
            transmission_complete <= 1'b0; // Reset the completion signal if SS is high
        end
    end
endmodule