module shift_register (
    input clk,
    input reset,
    input serial_in,
    output [7:0] parallel_out
);
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'b00000000;
        else
            shift_reg <= {shift_reg[6:0], serial_in};
    end

    assign parallel_out = shift_reg;

endmodule