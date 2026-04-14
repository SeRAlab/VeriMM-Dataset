module top_module(
    output reg [31:0] dout,
    input Z,  
    input V,  
    input N,  
    input [3:1] ctrl
);always @(*) begin
    dout[31:1] = 31'b0;  
    case (ctrl)
        3'b001:  
            dout[0] = Z;
        3'b000:  
            dout[0] = ~Z;
        3'b010:  
            dout[0] = N;
        3'b110:  
            dout[0] = N | Z;
        3'b100:  
            dout[0] = ~N;
        3'b111:  
            dout[0] = ~(N | Z);
        default:  
            dout[0] = 1'b0;
    endcase
end

endmodule