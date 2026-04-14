module top_module(
    input wire a, b, c, d,
    output wire [15:0] f
    );wire an = ~a;
    wire bn = ~b;
    wire cn = ~c;
    wire dn = ~d;
    assign f[0] = an & bn & cn & dn;
    assign f[1] = an & bn & cn & d;
    assign f[2] = an & bn & c & dn;
    assign f[3] = an & bn & c & d;
    assign f[4] = an & b & cn & dn;
    assign f[5] = an & b & cn & d;
    assign f[6] = an & b & c & dn;
    assign f[7] = an & b & c & d;
    assign f[8] = a & bn & cn & dn;
    assign f[9] = a & bn & cn & d;
    assign f[10] = a & bn & c & dn;
    assign f[11] = a & bn & c & d;
    assign f[12] = a & b & cn & dn;
    assign f[13] = a & b & cn & d;
    assign f[14] = a & b & c & dn;
    assign f[15] = a & b & c & d;
endmodule