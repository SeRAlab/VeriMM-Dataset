module shift_register_8bit (
    input clk,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);

reg [7:0] shift_reg;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data_in;
    end else begin
        shift_reg <= {shift_reg[6:0], 1'b0};
    end
end

assign data_out = shift_reg;

endmodule