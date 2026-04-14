module byte_setter (
    input [31:0] in,
    input [1:0] byte_num,
    output [31:0] out
);

    assign out = in;
    
    always @(*) begin
        case (byte_num)
            2'b00: out[7:0] = 8'h01;
            2'b01: out[15:8] = 8'h01;
            2'b10: out[23:16] = 8'h01;
            2'b11: out[31:24] = 8'h01;
        endcase
    end

endmodule