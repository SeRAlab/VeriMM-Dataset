module shift_register(
    input clk,
    input rst_n,
    input [3:0] data_in,
    output reg [3:0] data_out
);

reg [3:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shift_reg <= 4'd0;
    else
        shift_reg <= {shift_reg[2:0], data_in[0]};
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_out <= 4'd0;
    else
        data_out <= shift_reg;
end

endmodule