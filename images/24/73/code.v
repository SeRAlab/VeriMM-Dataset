module serializer (
    input wire clk,
    input wire rst,
    input wire ser_en,
    input wire [15:0] data_in,
    output reg serial_out
);
    reg [3:0] bit_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 4'b0000;
            serial_out <= 1'b0;
        end else if (ser_en) begin
            if (bit_count < 16) begin
                serial_out <= data_in[15 - bit_count];
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 4'b0000; // reset after sending all bits
            end
        end
    end
endmodule