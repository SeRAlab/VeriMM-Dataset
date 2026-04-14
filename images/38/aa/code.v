module serializer (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] parallel_in,
    output reg serial_out,
    output reg ready
);
    reg [2:0] bit_index; // 3-bit index to count from 0 to 7

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_index <= 3'b000;
            serial_out <= 1'b0;
            ready <= 1'b1; // Ready to start
        end else if (start && ready) begin
            serial_out <= parallel_in[bit_index]; // Output the current bit
            if (bit_index < 3'b111) begin
                bit_index <= bit_index + 1; // Move to the next bit
            end else begin
                ready <= 1'b1; // All bits sent, ready for the next transmission
                bit_index <= 3'b000; // Reset index
            end
        end else begin
            ready <= 1'b0; // Not ready if not starting
        end
    end
endmodule