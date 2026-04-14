module serializer (
    input clk,
    input rst,
    input start,
    input [15:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [3:0] count; // 4-bit counter for 16 bits
    reg [15:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            serial_out <= 0;
            done <= 0;
            shift_reg <= 0;
        end else if (start) begin
            shift_reg <= parallel_in;
            count <= 0;
            done <= 0;
        end else if (count < 16) begin
            serial_out <= shift_reg[15]; // Send the MSB first
            shift_reg <= shift_reg << 1; // Shift left
            count <= count + 1;
        end else begin
            done <= 1; // Indicate that serialization is done
        end
    end
endmodule