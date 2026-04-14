module decoder_3to8(
    input enable, 
    input [2:0] a, 
    output reg [7:0] y);

    always @(*) begin
        if (enable)
            y = 1 << a;
        else
            y = 8'b00000000;
    end
endmodule