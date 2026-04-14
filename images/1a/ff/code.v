module spi_master (
    input wire clk,
    input wire cs, // Chip Select
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg transfer_complete
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge cs) begin
        if (!cs) begin
            shift_reg <= data_in;
            bit_count <= 3'b000;
            transfer_complete <= 0;
        end else if (bit_count < 3'b111) begin
            data_out[bit_count] <= shift_reg[7];
            shift_reg <= {shift_reg[6:0], 1'b0};
            bit_count <= bit_count + 1;
        end else begin
            transfer_complete <= 1;
        end
    end
endmodule