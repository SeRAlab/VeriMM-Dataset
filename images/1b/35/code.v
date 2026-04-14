module serializer_32bit (
    input wire clk,
    input wire enable,
    input wire [31:0] data_in,
    output reg serial_out
);
    reg [4:0] bit_index; // 5 bits to count 0 to 31

    always @(posedge clk) begin
        if (enable) begin
            if (bit_index < 32) begin
                serial_out <= data_in[bit_index];
                bit_index <= bit_index + 1;
            end else begin
                bit_index <= 0; // Reset index after serialization
            end
        end
    end
endmodule