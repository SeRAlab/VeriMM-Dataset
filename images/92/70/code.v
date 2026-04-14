module top_module(i_in, direction, shift_amount, rot_prod);input  [31:0] i_in;
input         direction;
input  [4:0]  shift_amount;
output [31:0] rot_prod;



generate
genvar i, j;
        for (i = 0; i < 5; i = i + 1)
        begin : netgen
                wire [31:0] in;
                reg [31:0] out;
                for (j = 0; j < 32; j = j + 1)
                begin : net
                        always @*
                                out[j] = in[j] & (~shift_amount[i] ^ direction) |
                                         in[wrap(j, i)] & (shift_amount[i] ^ direction);
                end
        end

        
        assign netgen[4].in = i_in;
        for (i = 1; i < 5; i = i + 1)
        begin : router
                assign netgen[i-1].in = netgen[i].out;
        end
endgenerate


assign rot_prod = netgen[0].out;

function [4:0] wrap;
input integer pos;
input integer level;
integer out;
begin
        out = pos - (1 << level);
        wrap = out[4:0];
end
endfunction

endmodule