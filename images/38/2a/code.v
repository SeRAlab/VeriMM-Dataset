module serializer (
    input clk,
    input reset,
    input [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            serial_out <= 0;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            if (bit_count < 8) begin
                serial_out <= shift_reg[7]; // Shift out MSB first
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                bit_count <= bit_count + 1;
            end else begin
                serial_out <= 1'b0; // Keep output at 0 after 8 bits
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= parallel_in; // Load input on reset
            bit_count <= 0;
        end
    end
endmodule