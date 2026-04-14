module decoder_8to256(
    input [7:0] in,
    output reg [255:0] out
    );

    always @(*) begin
        case (in)
            8'd0: out = 256'b1;
            8'd1: out = 256'b10;
            8'd2: out = 256'b100;
            8'd3: out = 256'b1000;
            // ...
            8'd252: out = 256'b1 << 252;
            8'd253: out = 256'b1 << 253;
            8'd254: out = 256'b1 << 254;
            8'd255: out = 256'b1 << 255;
            default: out = 256'b0;
        endcase
    end
endmodule