module deserializer(
    input wire clk,
    input wire serial_in,
    output reg [7:0] parallel_out,
    input wire reset
);
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b0;
            parallel_out <= 8'b0;
        end else begin
            if (bit_count < 3'd8) begin
                parallel_out[bit_count] <= serial_in;
                bit_count <= bit_count + 1;
            end
        end
    end
endmodule