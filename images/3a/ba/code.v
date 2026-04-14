module deserializer (
    input clk,
    input reset,
    input serial_in,
    input valid,
    output reg [7:0] parallel_out,
    output reg data_ready
);
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b000;
            parallel_out <= 8'b00000000;
            data_ready <= 0;
        end else if (valid) begin
            parallel_out[bit_count] <= serial_in;
            if (bit_count == 3'b111) begin
                data_ready <= 1;
                bit_count <= 3'b000; // Reset the count after 8 bits received
            end else begin
                bit_count <= bit_count + 1;
                data_ready <= 0;
            end
        end
    end
endmodule