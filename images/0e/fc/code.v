module piso_shift_register (
    input clk,
    input load,
    input shift,
    input [4:0] parallel_data,
    output reg serial_out
);
    reg [4:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_data; // Load parallel data
        end else if (shift) begin
            serial_out <= shift_reg[0]; // Output the least significant bit
            shift_reg <= {1'b0, shift_reg[4:1]}; // Shift left
        end
    end
endmodule