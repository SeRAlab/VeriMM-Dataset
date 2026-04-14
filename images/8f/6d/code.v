module piso_shift_reg(
    input clk,
    input load,
    input [7:0] data_in,
    output reg data_out
);

    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data_in;
        end else begin
            shift_reg <= shift_reg >> 1;
        end
        data_out <= shift_reg[0];
    end

endmodule