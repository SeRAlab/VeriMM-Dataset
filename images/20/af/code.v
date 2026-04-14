module piso_shift_register (
    input wire clk,
    input wire load,
    input wire [3:0] parallel_in,
    output reg serial_out
);
    reg [3:0] shift_reg;
    integer count;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load parallel input when load is high
            count <= 0;               // Reset the count
        end else begin
            if (count < 4) begin
                serial_out <= shift_reg[3]; // Output the MSB
                shift_reg <= {shift_reg[2:0], 1'b0}; // Shift left
                count <= count + 1; // Increment count
            end else begin
                serial_out <= 1'b0; // After 4 bits, output 0
            end
        end
    end
endmodule