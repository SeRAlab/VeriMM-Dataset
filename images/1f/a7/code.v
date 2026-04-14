module barrel_shifter (
    input [3:0] data_in,
    input [1:0] ctrl,
    output reg [3:0] data_out
);

always @(*) begin
    case (ctrl)
        2'b00: data_out = data_in;                // No shift
        2'b01: data_out = data_in << 1;           // Shift left by 1
        2'b10: data_out = data_in << 2;           // Shift left by 2
        2'b11: data_out = data_in << 3;           // Shift left by 3
    endcase
end
endmodule