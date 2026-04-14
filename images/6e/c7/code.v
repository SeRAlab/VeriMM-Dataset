module top_module(
    input [3:0] sel,
    input [31:0] x,
    input [31:0] y,
    output reg [31:0] o,
    output reg v,
    output reg z,
    output reg s,
    output reg c
);parameter ADD =  4'b0000;
parameter SUB =  4'b0001;
parameter AND =  4'b0010;
parameter OR =   4'b0011;
parameter XOR =  4'b0100;
parameter SSLT = 4'b0101;
parameter USLT = 4'b0110;
parameter SLL =  4'b0111;
parameter SLR =  4'b1000;
parameter SRA =  4'b1001;

always @ (sel or x or y)
begin
    c = 0; v = 0;
    
    case (sel)
        ADD: begin {c, o} = x + y; v = c ^ x[31] ^ y[31] ^ o[31]; end               
        SUB: begin o = x - y; v = c ^ x[31] ^ y[31] ^ o[31]; end                    
        AND: o = x & y;                                                             
        OR: o = x | y;                                                              
        XOR: o = x ^ y;                                                             
        SSLT: o = ($signed(x) < $signed(y))? 32'h00000001 : 32'h00000000;           
        USLT: o = (x < y)? 32'h00000001 : 32'h00000000;                             
        SLL: o = x << y[4:0];                                                       
        SLR: o = x >> y[4:0];                                                       
        SRA: o =  $signed(x) >>> y[4:0];                                            
        default: o = 32'hxxxxxxxx;                                                  
    endcase
    
    s = o[31];
    z = (o == 1'b0)? 32'h00000001 : 32'h00000000;
end

endmodule