module PISO_Shift_Register (
    input clk,
    input load,
    input [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;
    integer count;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load data
            count <= 0; // Reset count for shifting
        end else begin
            if (count < 5) begin
                serial_out <= shift_reg[4]; // Output the MSB
                shift_reg <= {shift_reg[3:0], 1'b0}; // Shift left
                count <= count + 1; // Increment count
            end else begin
                serial_out <= 1'b0; // Output 0 when done
            end
        end
    end
endmodule