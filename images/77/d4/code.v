module shift_register (
    input [7:0] data_in,
    input load,
    input clk,
    output reg serial_out
);

    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (load)
            shift_reg <= data_in;
        else
            shift_reg <= shift_reg >> 1;
    end

    assign serial_out = shift_reg[0];

endmodule