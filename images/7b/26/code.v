module top_module(
    input select,
    input [3:0] a,
    output  reg [6:0]b
    );wire t1,t2,t3;
xor x1(t1,a[0],a[1],a[3]);
xor x2(t2,a[0],a[2],a[3]);
xor x3(t3,a[1],a[2],a[3]);
always@(*)
begin
case({select,t3,t2,t1})
4'b0000: begin b[0]=t1;b[1]=t2;b[3]=t3; end
4'b0001:  begin b[0]=t1;b[1]=t2;b[3]=t3; end
4'b0010:  begin b[0]=t1;b[1]=t2;b[3]=t3; end
4'b0011: begin b[0]=t1;b[1]=t2;b[3]=t3; end
4'b0100: begin b[0]=t1;b[1]=t2;b[3]=t3; end
4'b0101: begin b[0]=t1;b[1]=t2;b[3]=t3; end
4'b0110: begin b[0]=t1;b[1]=t2;b[3]=t3; end
4'b0111: begin b[0]=t1;b[1]=t2;b[3]=t3; end

4'b1000: begin b[0]=~t1;b[1]=~t2;b[3]=~t3; end
4'b1001: begin b[0]=~t1;b[1]=~t2;b[3]=~t3; end
4'b1010: begin b[0]=~t1;b[1]=~t2;b[3]=~t3; end
4'b1011: begin b[0]=~t1;b[1]=~t2;b[3]=~t3; end
4'b1100: begin b[0]=~t1;b[1]=~t2;b[3]=~t3; end
4'b1101: begin b[0]=~t1;b[1]=~t2;b[3]=~t3; end
4'b1110: begin b[0]=~t1;b[1]=~t2;b[3]=~t3; end
4'b1111: begin b[0]=~t1;b[1]=~t2;b[3]=~t3; end
endcase
b[2]=a[0];
b[4]=a[1];
b[5]=a[2];
b[6]=a[3];
end
endmodule