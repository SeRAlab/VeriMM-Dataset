module piso_shift_register (
    input clk,
    input rst,
    input load,
    input shift,
    input [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;
    integer index;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b0;
            serial_out <= 1'b0;
            index <= 0;
        end else if (load) begin
            shift_reg <= parallel_in;
            index <= 4; // Set index to point to the highest bit
        end else if (shift && index >= 0) begin
            serial_out <= shift_reg[index];
            index <= index - 1;
        end
    end
endmodule