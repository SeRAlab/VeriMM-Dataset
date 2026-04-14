module shift_left (
    input [3:0] in,
    output reg [3:0] out
);

always @ (in) begin
    out[0] = in[3];
    out[1] = in[0];
    out[2] = in[1];
    out[3] = in[2];
end

endmodule