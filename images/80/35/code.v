module shift_register(
    input clk,
    input load,
    input [7:0] data_in,
    output reg serial_out
);

    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (load)
            shift_reg <= data_in;
        else
            shift_reg <= {1'b0, shift_reg[7:1]};
        serial_out <= shift_reg[0];
    end

endmodule