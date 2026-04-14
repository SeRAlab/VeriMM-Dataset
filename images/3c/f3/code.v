module deserializer (
    input clk,
    input rst,
    input serial_in,
    output reg [7:0] parallel_out,
    output reg data_ready
);
    reg [2:0] bit_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 3'b000;
            parallel_out <= 8'b00000000;
            data_ready <= 0;
        end else begin
            if (bit_count < 8) begin
                parallel_out[bit_count] <= serial_in;
                bit_count <= bit_count + 1;
                data_ready <= 0;
            end
            if (bit_count == 7) begin
                data_ready <= 1;
            end
            if (bit_count == 8) begin
                bit_count <= 3'b000; // reset for the next 8 bits
            end
        end
    end
endmodule