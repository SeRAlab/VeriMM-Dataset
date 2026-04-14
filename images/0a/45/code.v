module barrel_shifter (
    input [31:0] data_in,
    input [4:0] shift_amount,
    input shift_direction, // 0 for left, 1 for right
    output reg [31:0] data_out
);
    
    always @(*) begin
        if (shift_direction) begin
            // Shift Right
            data_out = data_in >> shift_amount;
        end else begin
            // Shift Left
            data_out = data_in << shift_amount;
        end
    end
endmodule