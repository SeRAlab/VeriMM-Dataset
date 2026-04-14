module multiplexer(
    input [1:0] select,
    input [3:0] in,
    output reg out);always @(*) begin
    case (select)
        2'd0: out = in[0];
        2'd1: out = in[1];
        2'd2: out = in[2];
        2'd3: out = in[3];
        default: out = 1'b0;
    endcase
end
endmodule