module top_module(
    input ck,
    input ser_in,
    input [63:0] d_in,
    input shift_l,
    input load_l,
    output reg [63:0] d_out
);reg [63:0] shift_reg;

always @(posedge ck) begin
    if (load_l == 1'b0) begin
        shift_reg <= d_in;
    end else if (shift_l == 1'b1) begin
        d_out <= shift_reg;
    end else if (shift_l == 1'b0) begin
        shift_reg <= {shift_reg[62:0], ser_in};
        d_out <= shift_reg;
    end
end

endmodule