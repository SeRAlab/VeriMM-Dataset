module shift_register (
    input [3:0] data_in,
    input load,
    input shift_left,
    input shift_right,
    output [3:0] data_out
);

reg [3:0] shift_reg;

always @ (posedge load) begin
    shift_reg <= data_in;
end

always @ (posedge shift_left) begin
    shift_reg <= {shift_reg[2:0], 1'b0};
end

always @ (posedge shift_right) begin
    shift_reg <= {1'b0, shift_reg[3:1]};
end

assign data_out = shift_reg;

endmodule