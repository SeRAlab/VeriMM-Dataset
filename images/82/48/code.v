module mux_4to1_16bit(
    input [15:0]        a    ,
    input [15:0]        b    ,
    input [15:0]        c    ,
    input [15:0]        d    ,
    input [1:0]         sel  ,
    output reg [15:0]   y     
);

always @(*) begin
    case (sel)
        2'b00: y = a;
        2'b01: y = b;
        2'b10: y = c;
        2'b11: y = d;
        default: y = 16'd0;
    endcase
end

endmodule