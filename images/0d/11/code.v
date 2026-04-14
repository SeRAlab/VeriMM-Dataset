module serializer (
    input clk,
    input reset,
    input enable,
    input [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] count;  // 3-bit counter to keep track of bits shifted out
    reg [7:0] shift_reg; // Shift register to hold the parallel input

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            serial_out <= 1'b0;
            shift_reg <= 8'b00000000;
        end else if (enable) begin
            if (count < 3'b111) begin  // Only shift out 8 bits
                serial_out <= shift_reg[7];
                shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                count <= count + 1;
            end else begin
                serial_out <= 1'b0; // Output zero after 8 bits
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= parallel_in; // Load parallel input on reset
        end
    end
endmodule