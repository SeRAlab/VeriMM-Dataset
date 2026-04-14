module decoder_2to4 (
    input [1:0] bin,
    input en,
    output reg [3:0] dec);
    
    always @(*) begin
        if (en)
            case (bin)
                2'b00: dec = 4'b0001;
                2'b01: dec = 4'b0010;
                2'b10: dec = 4'b0100;
                2'b11: dec = 4'b1000;
                default: dec = 4'b0000;
            endcase
        else
            dec = 4'b0000;
    end
    
endmodule