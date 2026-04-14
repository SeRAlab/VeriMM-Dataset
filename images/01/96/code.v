module serializer (
    input clk,
    input shift_en,
    input [7:0] data_in,
    output reg serial_out
);
    reg [2:0] bit_count; // 3-bit counter for 8 bits

    always @(posedge clk) begin
        if (shift_en) begin
            serial_out <= data_in[7 - bit_count]; // Shift out MSB first
            if (bit_count < 7)
                bit_count <= bit_count + 1;
            else
                bit_count <= 0; // Reset counter after 8 bits
        end
    end

    initial begin
        bit_count = 0;
        serial_out = 0;
    end
endmodule