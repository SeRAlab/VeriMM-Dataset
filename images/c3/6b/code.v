module mux_4to1(
    input [3:0] data_in,
    input [1:0] select,
    output reg out
);

always @*
begin
    case (select)
        2'b00: out = data_in[0];
        2'b01: out = data_in[1];
        2'b10: out = data_in[2];
        2'b11: out = data_in[3];
        default: out = 0;
    endcase
end

endmodule