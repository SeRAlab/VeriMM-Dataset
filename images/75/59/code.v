module top_module(
    input [3:0] a,b,c,d,e,f,g,h,i,
    output reg [2:0] x,y,z,
    output reg ovf );reg [3:0] xor1, xor2, sum;

    always @(*) begin
        xor1 = {a,b,c,d} ^ e;
        xor2 = {f,g,h,i} ^ e;
        sum = xor1 + xor2 + e;
        x = sum[0];
        y = sum[1];
        z = sum[2];
        ovf = sum[3];
    end

endmodule