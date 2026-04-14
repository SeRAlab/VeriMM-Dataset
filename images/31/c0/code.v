module serializer (
    input wire clk,
    input wire reset,
    input wire shift_enable,
    input wire [7:0] parallel_data,
    output reg serial_out
);
    reg [2:0] bit_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_index <= 3'b000;
            serial_out <= 1'b0;
        end else if (shift_enable) begin
            serial_out <= parallel_data[bit_index];
            if (bit_index < 3'b111) begin
                bit_index <= bit_index + 1;
            end
        end
    end
endmodule