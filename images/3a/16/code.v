module serializer (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    output reg serial_out
);
    reg [2:0] bit_count; // To count the number of bits sent

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b000;
            serial_out <= 1'b0;
        end else if (enable) begin
            if (bit_count < 3'b111) begin
                serial_out <= data_in[7 - bit_count]; // Send MSB first
                bit_count <= bit_count + 1;
            end else begin
                serial_out <= 1'b0; // After 8 bits, output is default
            end
        end
    end
endmodule