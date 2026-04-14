module serializer (
    input clk,
    input reset,
    input [7:0] data_in,
    output reg serial_out
);
    reg [2:0] bit_index; // 3 bits to count from 0 to 7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            serial_out <= 0;
            bit_index <= 0;
        end else if (bit_index < 8) begin
            serial_out <= data_in[bit_index];
            bit_index <= bit_index + 1;
        end
    end
endmodule