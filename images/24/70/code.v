module PISO (
    input wire clk,
    input wire load,
    input wire [3:0] parallel_in,
    output reg serial_out
);
    reg [3:0] shift_reg;
    reg [2:0] count;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load parallel data
            count <= 3'b100; // Set count to 4 (for 4 bits)
        end else if (count > 0) begin
            serial_out <= shift_reg[3]; // Output the most significant bit
            shift_reg <= shift_reg << 1; // Shift left
            count <= count - 1; // Decrement the count
        end
    end
endmodule