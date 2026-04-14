module verified_decoder_3to8(
    input en,
    input [2:0] addr,
    
    output reg [7:0] out
);
    always @(*) begin
        if (en)
            out = 8'b00000001 << addr;
        else
            out = 8'b00000000;
    end
endmodule