module deserializer (
    input clk,
    input rst,
    input serial_in,
    output reg [7:0] parallel_out,
    output reg valid
);
    reg [2:0] bit_count; // to count the bits received

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 3'b000;
            parallel_out <= 8'b00000000;
            valid <= 0;
        end else if (bit_count < 3'b111) begin
            parallel_out <= {serial_in, parallel_out[7:1]}; // shift in the new bit
            bit_count <= bit_count + 1;
            valid <= 0; // not valid until all bits are received
        end else begin
            valid <= 1; // 8 bits received
            bit_count <= 3'b000; // reset bit count after valid output
        end
    end
endmodule