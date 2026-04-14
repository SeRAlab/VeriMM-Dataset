module serializer (
    input wire clk,
    input wire enable,
    input wire [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] bit_count; // to count the number of bits shifted out
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (enable) begin
            if (bit_count < 8) begin
                shift_reg <= parallel_in; // load parallel input on first clock
                serial_out <= shift_reg[7]; // output the MSB
                shift_reg <= {shift_reg[6:0], 1'b0}; // shift left
                bit_count <= bit_count + 1; // increment bit counter
            end
        end else begin
            bit_count <= 0; // reset the counter if not enabled
        end
    end
endmodule