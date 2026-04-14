module top_module(in, out);input [3:0] in;
    output reg [3:0] out; // Change to reg type for output

    always @ (in) begin
        case (in)
            4'b0100: out = 4'b0000;
            4'b0101: out = 4'b0001;
            4'b0110: out = 4'b0010;
            4'b0111: out = 4'b0011;
            4'b1000: out = 4'b0100;
            4'b1001: out = 4'b0101;
            default: out = 4'b0000;
        endcase
    end
endmodule