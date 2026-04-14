module top_module(
    input [3:0] din,
    input load,
    input shift,
    output [3:0] dout
);reg [3:0] shift_reg;

always @ (posedge shift) begin
    shift_reg <= {shift_reg[2:0], 1'b0};
end

always @ (posedge load) begin
    if (load) begin
        shift_reg <= din;
    end
end

assign dout = shift_reg;

endmodule