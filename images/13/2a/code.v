module serializer (
    input clk,
    input rst_n,
    input [15:0] parallel_in,
    input start,
    output reg serial_out,
    output reg done
);
    reg [3:0] bit_count;
    reg [15:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count <= 0;
            serial_out <= 0;
            done <= 0;
            shift_reg <= 0;
        end else begin
            if (start) begin
                shift_reg <= parallel_in;
                bit_count <= 15; // Start from the MSB
                done <= 0;
            end else if (bit_count >= 0) begin
                serial_out <= shift_reg[bit_count];
                bit_count <= bit_count - 1;
            end
            
            if (bit_count == 0) begin
                done <= 1; // Serialization complete
            end
        end
    end
endmodule