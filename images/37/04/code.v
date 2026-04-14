module piso_shift_register (
    input wire [3:0] parallel_in,
    input wire load,
    input wire clk,
    output reg serial_out
);
    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load parallel data
        end else begin
            serial_out <= shift_reg[3]; // Output the most significant bit
            shift_reg <= {shift_reg[2:0], 1'b0}; // Shift left
        end
    end
endmodule