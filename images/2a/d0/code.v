module deserializer (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [31:0] parallel_out,
    output reg valid
);
    reg [4:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 0;
            parallel_out <= 0;
            valid <= 0;
        end else begin
            if (bit_count < 32) begin
                parallel_out[bit_count] <= serial_in;
                bit_count <= bit_count + 1;
                valid <= 0;
            end
            if (bit_count == 31) begin
                valid <= 1; // Indicate that we have a valid output
            end
        end
    end
endmodule