module top_module(
    output reg [31:0] dout,
    input [31:0] B,
    input [1:0] ctrl,
    input enable
);parameter SHIFT_AMOUNT = 1;

wire signed [31:0] signedB = B;

always @(*) begin
    if (enable)
        case (ctrl)
            2'b00:  
                dout = B << SHIFT_AMOUNT;
            2'b01:  
                dout = B >> SHIFT_AMOUNT;
            2'b11:  
                dout = signedB >>> SHIFT_AMOUNT;
            default:
                dout = B;
        endcase
    else
        dout = B;
end

endmodule