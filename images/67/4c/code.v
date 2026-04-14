module top_module(
    input a,b,cin,
    output s,cout
    );assign #1 s = a ^ b ^ cin;
    assign #1 cout = (a&b)|(a&cin)|(b&cin);
    
endmodule