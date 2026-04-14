module serializer (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg serial_out
);
    reg [2:0] bit_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_index <= 3'b000;
            serial_out <= 1'b0;
        end else begin
            if (bit_index < 3'b111) begin
                serial_out <= data_in[bit_index];
                bit_index <= bit_index + 1'b1;
            end
        end
    end
endmodule