module top_module(
    input A1,
    input A2,
    input A3,
    input A4,
    output reg [3:0] Y
);always @(*) begin
        case ({A4, A3, A2, A1})
            4'b0000: Y = 4'd0;
            4'b0001: Y = 4'd1;
            4'b0010: Y = 4'd2;
            4'b0011: Y = 4'd3;
            4'b0100: Y = 4'd4;
            4'b0101: Y = 4'd5;
            4'b0110: Y = 4'd6;
            4'b0111: Y = 4'd7;
            4'b1000: Y = 4'd8;
            4'b1001: Y = 4'd9;
            4'b1010: Y = 4'd10;
            4'b1011: Y = 4'd11;
            4'b1100: Y = 4'd12;
            4'b1101: Y = 4'd13;
            4'b1110: Y = 4'd14;
            4'b1111: Y = 4'd15;
        endcase
    end

endmodule