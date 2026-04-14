module top_module(
    input [3:0] a,
    input [3:0] b,
    input mode,
    output reg [3:0] out,
    output reg overflow
);reg [3:0] sum;
reg carry_in;
reg [3:0] diff;

always @(*) begin
    if (mode == 0) begin
        sum[0] = a[0] ^ b[0] ^ carry_in;
        carry_in = (a[0] & b[0]) | (a[0] & carry_in) | (b[0] & carry_in);
        sum[1] = a[1] ^ b[1] ^ carry_in;
        carry_in = (a[1] & b[1]) | (a[1] & carry_in) | (b[1] & carry_in);
        sum[2] = a[2] ^ b[2] ^ carry_in;
        carry_in = (a[2] & b[2]) | (a[2] & carry_in) | (b[2] & carry_in);
        sum[3] = a[3] ^ b[3] ^ carry_in;
        overflow = carry_in;
        out = sum;
    end else begin
        diff[0] = a[0] ^ b[0] ^ carry_in;
        carry_in = (~a[0] & b[0]) | ((~a[0] | b[0]) & carry_in);
        diff[1] = a[1] ^ b[1] ^ carry_in;
        carry_in = (~a[1] & b[1]) | ((~a[1] | b[1]) & carry_in);
        diff[2] = a[2] ^ b[2] ^ carry_in;
        carry_in = (~a[2] & b[2]) | ((~a[2] | b[2]) & carry_in);
        diff[3] = a[3] ^ b[3] ^ carry_in;
        overflow = carry_in;
        out = diff;
    end
end

endmodule