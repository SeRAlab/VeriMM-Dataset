module PISO (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b00000;
            serial_out <= 1'b0;
        end else if (load) begin
            shift_reg <= parallel_in;
            serial_out <= shift_reg[4]; // Output the MSB initially
        end else begin
            serial_out <= shift_reg[4]; // Output the MSB
            shift_reg <= {shift_reg[3:0], 1'b0}; // Shift left
        end
    end
endmodule