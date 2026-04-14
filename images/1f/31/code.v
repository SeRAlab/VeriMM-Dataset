module piso_shift_register (
    input wire clk,
    input wire load,
    input wire shift,
    input wire [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;
    integer count;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load parallel data into shift register
            count <= 0; // Reset count for shifting
        end else if (shift && count < 5) begin
            serial_out <= shift_reg[0]; // Output LSB
            shift_reg <= shift_reg >> 1; // Shift right
            count <= count + 1; // Increment count
        end
    end
endmodule