module barrel_shifter (
    input [3:0] data,
    input [2:0] shift,
    output [3:0] out
);

    reg [3:0] shift_reg;

    always @(*) begin
        if (shift > 3) begin
            shift_reg[0] = data[3];
            shift_reg[1] = data[0];
            shift_reg[2] = data[1];
            shift_reg[3] = data[2];
        end else begin
            shift_reg = data << shift;
        end
    end

    assign out = shift_reg;

endmodule