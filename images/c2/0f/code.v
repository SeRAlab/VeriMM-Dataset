module shift_register #(parameter WIDTH = 8) (
    input clk,
    input load,
    input [WIDTH-1:0] data_in,
    input shift,
    output reg [WIDTH-1:0] data_out
);

reg [WIDTH-1:0] shift_reg;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data_in;
    end else if (shift) begin
        shift_reg <= {shift_reg[WIDTH-2:0], shift_reg[WIDTH-1]};
    end
end

assign data_out = shift_reg;

endmodule