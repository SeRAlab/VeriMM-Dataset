module top_module(output reg [31:0] ext, input [31:0] unext, input size, en);parameter BYTE = 1'b0;
    parameter HALF = 1'b1;

    always @ (unext) begin
        if(en)
            case(size)
                BYTE: ext <= {{24{unext[7]}},unext[7:0]};
                HALF: ext <= {{16{unext[15]}},unext[15:0]};
            endcase
        else
            ext <= unext;
    end
endmodule