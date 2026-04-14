module serializer(
    input wire clk,
    input wire start,
    input wire enable,
    input wire [31:0] data_in,
    output reg serial_out,
    output reg done
);
    reg [5:0] bit_counter; // 6 bits to count from 0 to 31
    reg [31:0] shift_reg;

    always @(posedge clk) begin
        if (start) begin
            bit_counter <= 0;
            shift_reg <= data_in;
            done <= 0;
        end else if (enable) begin
            if (bit_counter < 32) begin
                serial_out <= shift_reg[31]; // Output the MSB
                shift_reg <= shift_reg << 1; // Shift left to move next bit to MSB
                bit_counter <= bit_counter + 1;
            end else begin
                serial_out <= 0; // No more bits to serialize
                done <= 1; // Serialization is done
            end
        end
    end
endmodule