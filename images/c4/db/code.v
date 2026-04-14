module barrel_shifter (
    input [7:0] DATA,
    input [2:0] SHIFT_AMOUNT,
    input SHIFT_DIRECTION,
    output [7:0] SHIFTED_DATA
);

    reg [7:0] shifted_data;

    always @(*) begin
        if (SHIFT_DIRECTION == 0) begin
            shifted_data = DATA << SHIFT_AMOUNT;
        end else begin
            shifted_data = DATA >> SHIFT_AMOUNT;
        end
    end

    assign SHIFTED_DATA = shifted_data;

endmodule