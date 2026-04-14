module shift_register_8bit(
    input [7:0] data_in,
    input clk,
    input load,
    output reg data_out
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    if (load)
        shift_reg <= data_in;
    else
        shift_reg <= {shift_reg[6:0], 1'b0};
end

always @(posedge clk) begin
    data_out <= shift_reg[7];
end

endmodule