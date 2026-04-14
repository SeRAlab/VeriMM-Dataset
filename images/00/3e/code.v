module deserializer (
    input clk,
    input rst,
    input serial_in,
    input valid,
    output reg [7:0] parallel_out,
    output reg data_ready
);
    reg [2:0] bit_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 3'b000;
            parallel_out <= 8'b0;
            data_ready <= 1'b0;
        end else if (valid) begin
            if (bit_count < 3'b111) begin
                parallel_out[bit_count] <= serial_in;
                bit_count <= bit_count + 1;
                data_ready <= 1'b0;
            end
            if (bit_count == 3'b111) begin
                data_ready <= 1'b1;
            end
        end
    end
endmodule