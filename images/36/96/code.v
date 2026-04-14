module serializer (
    input clk,
    input rst,
    input [7:0] data_in,
    output reg serial_out
);
    reg [2:0] count; // 3-bit counter for 8 bits

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 3'b000;
            serial_out <= 1'b0;
        end else if (count < 3'b111) begin
            serial_out <= data_in[7 - count]; // Shift out the bits
            count <= count + 1;
        end else begin
            serial_out <= 1'b0; // After 8 bits, keep output low
        end
    end
endmodule