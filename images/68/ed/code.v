module demux_1to2 (
    input sel,
    input in,
    output reg [1:0] y
);

    always @(*) begin
        case (sel)
            1'b0: y = {1'b0, in};
            1'b1: y = {in, 1'b0};
            default: y = 2'b00;
        endcase
    end

endmodule