module top_module(
    input [2:0] sel,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] y,
    output reg v,
    output reg z,
    output reg c
);always @ (sel or a or b)
begin
    c = 0; v = 0;
    case (sel)
        0: y = 8'h00;
        1: y = a & b;
        2: y = a | b;
        3: y = a ^ b;
        4: y = ~a;
        5: begin y = a - b; v = c ^ a[7] ^ b[7] ^ y[7]; end
        6: begin {c, y} = a[6:0] + b[6:0]; v = c ^ a[7] ^ b[7] ^ y[7]; end
        7: y = 8'hFF;
        default: y = 8'hxx;
    endcase
     z = (y == 1'd0)? 1 : 0;
end

endmodule