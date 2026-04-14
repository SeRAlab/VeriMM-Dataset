module crc_generator (
    input clk,
    input rst,
    input [3:0] data,
    input [3:0] polynomial,
    output reg [3:0] crc
);
    reg [3:0] shift_reg;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc <= 4'b0000;
            shift_reg <= 4'b0000;
        end else begin
            shift_reg <= {shift_reg[2:0], data[0]}; // Shift in the new data bit
            for (i = 3; i >= 0; i = i - 1) begin
                if (shift_reg[3] == 1) begin
                    shift_reg = shift_reg ^ polynomial; // XOR with polynomial
                end
                shift_reg = {shift_reg[2:0], 1'b0}; // Shift left
            end
            crc <= shift_reg; // Output CRC
        end
    end
endmodule