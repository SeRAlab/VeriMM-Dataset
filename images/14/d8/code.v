module Serializer(
    input clk,
    input rst,
    input enable,
    input [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] bit_count; // 3 bits to count from 0 to 7
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 3'b000;
            serial_out <= 1'b0;
            shift_reg <= 8'b00000000;
        end else if (enable) begin
            if (bit_count < 3'b111) begin
                serial_out <= shift_reg[7]; // send out the most significant bit
                shift_reg <= {shift_reg[6:0], 1'b0}; // shift left
                shift_reg[0] <= parallel_in[bit_count]; // load new bit
                bit_count <= bit_count + 1;
            end
        end
    end
endmodule