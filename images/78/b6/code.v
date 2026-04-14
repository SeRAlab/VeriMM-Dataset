module top_module(in,out);input [4:1]in;
    output reg [8:1]out;
    always @(*) begin
        case (in)
            4'h0:out    = 8'b00000000;
            4'h1:out    = 8'b00000001;
            4'h2:out    = 8'b00000011;
            4'h3:out    = 8'b00000111;
            4'h4:out    = 8'b00001111;
            4'h5:out    = 8'b00011111;
            4'h6:out    = 8'b00111111;
            4'h7:out    = 8'b01111111;
            4'h8:out    = 8'b11111111;
            default:out = 8'bxxxxxxxx;
        endcase
    end
endmodule