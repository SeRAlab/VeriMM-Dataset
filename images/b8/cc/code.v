module top_module(
    input a,b,cin,
    output wire s,cout
    );assign #2 s = a ^ b ^ cin;
    assign #2 cout = (a&b)|(a&cin)|(b&cin);
    
endmodule