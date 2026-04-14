module decoder_1to2(
    input                 enable,
    input                 in,
    
    output reg [1:0]      out
);

// Decoder implementation
always @(*) begin
    if (enable) begin
        case (in)
            1'b0: out = 2'b01;
            1'b1: out = 2'b10;
            default: out = 2'b00;
        endcase
    end
    else begin
        out = 2'b00;
    end
end

endmodule