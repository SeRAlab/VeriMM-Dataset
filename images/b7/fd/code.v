module top_module(input [2:0] count,output reg [6:0] display);always @(count)
    begin
        case (count)
            0 : display = 7'b1111110;
            1 : display = 7'b0110000;
            2 : display = 7'b1101101;
            3 : display = 7'b1111001;
            4 : display = 7'b0110011;
            5 : display = 7'b1011011;
            6 : display = 7'b1011111;
            7 : display = 7'b1110000;
            default : display = 7'b1111111;
        endcase
    end

endmodule