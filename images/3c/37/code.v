module PISO (
    input wire clk,
    input wire load,
    input wire [7:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [7:0] shift_reg;
    reg [2:0] count;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load data
            count <= 3'b000;          // Reset count
            done <= 1'b0;             // Not done yet
        end else if (count < 3'b111) begin
            serial_out <= shift_reg[7]; // Shift out the MSB
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            count <= count + 1;         // Increment count
        end else begin
            serial_out <= shift_reg[7]; // Shift out the last bit
            done <= 1'b1;                // Indicate done
        end
    end
endmodule