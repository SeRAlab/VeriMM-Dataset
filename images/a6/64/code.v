module verified_mux_2to1(
    input [7:0] a,
    input [7:0] b,
    input sel,
    
    output reg [7:0] y
);
    always @(*) begin
        case(sel)
            1'b0: y = a;
            1'b1: y = b;
        endcase
    end
endmodule