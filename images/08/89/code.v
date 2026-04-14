module sipo_shift_register(
    input clk,
    input rst,
    input serial_in,
    output reg [4:0] parallel_out
);
    reg [4:0] shift_reg;
    integer count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b00000;
            count <= 0;
        end else if (count < 5) begin
            shift_reg <= {shift_reg[3:0], serial_in}; // Shift left and input new bit
            count <= count + 1;
        end
    end

    always @(posedge clk) begin
        if (count == 5) begin
            parallel_out <= shift_reg; // Output the shifted value
        end
    end
endmodule