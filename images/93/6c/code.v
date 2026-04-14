module top_module(a,b,cin,sum,cout);input a,b,cin;
output sum,cout;
reg cout,m1,m2,m3;
wire s1;


xor x1(s1,a,b);


always @(a or b or cin) begin
    m1 = a & b;
    m2 = b & cin;
    m3 = a & cin;
    cout = (m1 | m2) | m3;
end


assign
    sum = s1 ^ cin;
    
endmodule