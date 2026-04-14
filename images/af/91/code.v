module top_module(
    input [3:0] select,
    input [7:0] data_i00,
    input [7:0] data_i01,
    input [7:0] data_i02,
    input [7:0] data_i03,
    input [7:0] data_i04,
    input [7:0] data_i05,
    input [7:0] data_i06,
    input [7:0] data_i07,
    input [7:0] data_i08,
    input [7:0] data_i09,
    input [7:0] data_i10,
    input [7:0] data_i11,
    input [7:0] data_i12,
    input [7:0] data_i13,
    input [7:0] data_i14,
    input [7:0] data_i15,
    output reg [7:0] data_o
);always @(*) begin
    case (select)
        4'b0000: data_o = data_i00;
        4'b0001: data_o = data_i01;
        4'b0010: data_o = data_i02;
        4'b0011: data_o = data_i03;
        4'b0100: data_o = data_i04;
        4'b0101: data_o = data_i05;
        4'b0110: data_o = data_i06;
        4'b0111: data_o = data_i07;
        4'b1000: data_o = data_i08;
        4'b1001: data_o = data_i09;
        4'b1010: data_o = data_i10;
        4'b1011: data_o = data_i11;
        4'b1100: data_o = data_i12;
        4'b1101: data_o = data_i13;
        4'b1110: data_o = data_i14;
        4'b1111: data_o = data_i15;
    endcase
end

endmodule