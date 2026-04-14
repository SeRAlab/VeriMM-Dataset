module piso_shift_register (
    input wire clk,
    input wire rst,
    input wire [7:0] parallel_in,
    input wire load,
    output reg serial_out
);

    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            shift_reg <= 8'b00000000;
        else if (load)
            shift_reg <= parallel_in;
        else
            shift_reg <= {shift_reg[6:0], 1'b0};
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            serial_out <= 1'b0;
        else
            serial_out <= shift_reg[7];
    end

endmodule