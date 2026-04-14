module PISO_Shift_Register (
    input clk,
    input load,
    input [7:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [7:0] shift_reg;
    reg [2:0] count; // Counter to track the number of bits shifted out

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load parallel data
            count <= 3'b000; // Reset counter
            done <= 1'b0; // Not done shifting
        end else if (count < 3'b111) begin
            serial_out <= shift_reg[7]; // Output the MSB
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            count <= count + 1; // Increment the counter
        end else begin
            serial_out <= shift_reg[7]; // Output the last bit
            done <= 1'b1; // Indicate done shifting
        end
    end
endmodule