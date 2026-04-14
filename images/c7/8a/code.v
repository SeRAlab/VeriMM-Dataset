module square (
    input [3:0] in,
    output reg [7:0] out
);

    always @(*) begin
        out[7:4] = {2'b0, in[3:2]} * {2'b0, in[3:2]};
        out[3:0] = {2'b0, in[1:0]} * {2'b0, in[1:0]};
    end

endmodule