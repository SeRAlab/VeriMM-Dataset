module serializer (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [15:0] parallel_in,
    output reg serial_out
);
    reg [3:0] bit_counter; // 4-bit counter to count from 15 to 0
    reg [15:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_counter <= 4'd0;
            serial_out <= 1'b0;
            shift_reg <= 16'b0;
        end else if (enable) begin
            if (bit_counter < 16) begin
                serial_out <= shift_reg[15]; // Output MSB first
                shift_reg <= {shift_reg[14:0], 1'b0}; // Shift left
                bit_counter <= bit_counter + 1;
            end else begin
                bit_counter <= 4'd0; // Reset counter after 16 bits
                shift_reg <= parallel_in; // Load new data
            end
        end else begin
            shift_reg <= parallel_in; // Load new data when enable is low
        end
    end
endmodule