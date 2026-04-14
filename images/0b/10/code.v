module serializer (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [31:0] data_in,
    output reg serial_out,
    output reg done
);
    reg [5:0] bit_cnt; // 6 bits to count from 0 to 31
    reg [31:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_cnt <= 0;
            shift_reg <= 0;
            serial_out <= 0;
            done <= 0;
        end else if (start) begin
            shift_reg <= data_in;
            bit_cnt <= 0;
            done <= 0;
        end else if (bit_cnt < 32) begin
            serial_out <= shift_reg[31]; // Output the MSB
            shift_reg <= shift_reg << 1; // Shift left
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 31) begin
                done <= 1; // Serialization complete
            end
        end
    end
endmodule