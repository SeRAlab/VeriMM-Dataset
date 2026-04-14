module deserializer (
    input clk,
    input reset,
    input serial_in,
    output reg [15:0] parallel_out
);
    reg [15:0] shift_reg;
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 16'b0;
            count <= 4'b0;
            parallel_out <= 16'b0;
        end else begin
            shift_reg <= {shift_reg[14:0], serial_in}; // Shift in the new bit
            count <= count + 1;

            if (count == 4'b0111) begin // After 8 clock cycles
                parallel_out <= shift_reg; // Output the current state of the shift register
                count <= 4'b0; // Reset count
            end
        end
    end
endmodule