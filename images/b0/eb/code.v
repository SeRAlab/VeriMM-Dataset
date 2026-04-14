module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] out
);reg [7:0] temp_out;

always @(*) begin
    temp_out = {a[0]&b, a[1]&b, a[2]&b, a[3]&b};
    out = temp_out[0] + temp_out[1]*2 + temp_out[2]*4 + temp_out[3]*8 + temp_out[4]*16 + temp_out[5]*32 + temp_out[6]*64 + temp_out[7]*128;
end

endmodule