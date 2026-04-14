module shift_register (
    input clk,
    input rst_n,
    input load,
    input [15:0] parallel_in,
    input serial_in,
    output serial_out
);

    reg [15:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= 16'b0;
        else if (load)
            shift_reg <= parallel_in;
        else
            shift_reg <= {serial_in, shift_reg[15:1]};
    end

    assign serial_out = shift_reg[0];

endmodule