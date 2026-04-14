module PISO (
    input wire clk,
    input wire load,
    input wire shift,
    input wire [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in; // Load parallel input
        end else if (shift) begin
            serial_out <= shift_reg[4]; // Shift out the MSB
            shift_reg <= {shift_reg[3:0], 1'b0}; // Shift left
        end
    end
endmodule