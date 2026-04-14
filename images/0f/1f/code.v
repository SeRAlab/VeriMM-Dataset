module serializer (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg serial_out
);
    reg [2:0] bit_count; // 3 bits to count from 0 to 7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 0;
            serial_out <= 0;
        end else if (bit_count < 8) begin
            serial_out <= data_in[7 - bit_count]; // Shift out MSB first
            bit_count <= bit_count + 1;
        end
    end
endmodule