module serializer(
    input clk,
    input rst,
    input [7:0] data_in,
    output reg serial_out
);
    reg [2:0] bit_index; // 3 bits to index 0 to 7

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_index <= 0;
            serial_out <= 0;
        end else if (bit_index < 8) begin
            serial_out <= data_in[7 - bit_index];
            bit_index <= bit_index + 1;
        end
    end
endmodule