module piso_shift_register (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] parallel_in,
    output reg serial_out
);

    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 8'b0;
            serial_out <= 1'b0;
        end else if (load) begin
            shift_reg <= parallel_in;
        end else begin
            serial_out <= shift_reg[7]; // Output the MSB
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
        end
    end
endmodule