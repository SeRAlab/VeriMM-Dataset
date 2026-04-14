module top_module(
    input [3:0] data_in,
    input load, shift, reset, clk,
    output [3:0] data_out
);reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000;
    end else if (load) begin
        shift_reg <= data_in;
    end else if (shift) begin
        shift_reg <= {shift_reg[2:0], 1'b0};
    end
end

assign data_out = shift_reg;

endmodule