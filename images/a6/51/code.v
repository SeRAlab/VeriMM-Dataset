module top_module(
    input  [1:0] sel,
    input [11:0] din_a,
    input [11:0] din_b,
    input [11:0] din_c,
    
    output reg [11:0] dout
    );always@(*) begin
        case(sel)
            0: dout = din_a; 
            1: dout = din_b;
            2: dout = din_c; 
            default: dout = din_a;
        endcase
    end
endmodule