module signal_converter(
    input [3:0] in,
    output reg [1:0] out
);

always @(*) begin
    case (in)
        4'd0: out = 2'b00;
        4'd1: out = 2'b00;
        4'd2: out = 2'b00;
        4'd3: out = 2'b00;
        4'd4: out = 2'b00;
        4'd5: out = 2'b01;
        4'd6: out = 2'b01;
        4'd7: out = 2'b01;
        4'd8: out = 2'b01;
        4'd9: out = 2'b01;
        default: out = 2'b10;
    endcase
end

endmodule