module serializer (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg serial_out
);
    reg [2:0] bit_count; // 3 bits to count 0-7 for 8 bits
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b000;
            serial_out <= 1'b0;
            shift_reg <= 8'b0;
        end else begin
            if (bit_count < 3'b111) begin
                if (bit_count == 3'b000) begin
                    shift_reg <= data_in; // Load data on the first clock
                end
                serial_out <= shift_reg[7]; // Output the MSB
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                bit_count <= bit_count + 1;
            end else begin
                serial_out <= 1'b0; // After 8 bits, output 0
            end
        end
    end
endmodule