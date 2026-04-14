module piso_shift_register (
    input clk,
    input load,
    input shift,
    input [4:0] parallel_in,
    output reg serial_out
);
    reg [4:0] shift_reg;
    integer count;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= parallel_in;
            count <= 4; // Start shifting from the highest bit
        end else if (shift && count >= 0) begin
            serial_out <= shift_reg[count];
            count <= count - 1; // Move to the next bit
        end
    end
endmodule