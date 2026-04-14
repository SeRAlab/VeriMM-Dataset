module spi_controller (
    input wire clk,
    input wire cs,
    input wire mosi,
    output reg miso,
    output reg [4:0] data_out,
    input wire [4:0] data_in
);
    reg [4:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or negedge cs) begin
        if (!cs) begin
            bit_count <= 0;
            shift_reg <= data_in; // Load data_in into shift_reg when CS is low
        end else if (bit_count < 5) begin
            shift_reg <= {shift_reg[3:0], mosi}; // Shift in data on rising edge of clock
            bit_count <= bit_count + 1;
        end
    end

    always @(negedge clk or negedge cs) begin
        if (!cs) begin
            miso <= shift_reg[4]; // Shift out data on falling edge of clock
            data_out <= shift_reg; // Output the shift register data
        end
    end
endmodule