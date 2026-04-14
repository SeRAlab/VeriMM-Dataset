module serializer (
    input clk,
    input rst,
    input start,
    input [31:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [5:0] bit_counter; // 6 bits to count from 0 to 32
    reg [31:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_counter <= 6'd0;
            serial_out <= 1'b0;
            done <= 1'b0;
            shift_reg <= 32'd0;
        end else if (start) begin
            shift_reg <= parallel_in;
            bit_counter <= 6'd0;
            done <= 1'b0;
        end else if (bit_counter < 6'd32) begin
            serial_out <= shift_reg[31]; // shift out the MSB
            shift_reg <= shift_reg << 1; // shift left
            bit_counter <= bit_counter + 1;
            done <= (bit_counter == 6'd31); // done after 32 bits
        end
    end
endmodule