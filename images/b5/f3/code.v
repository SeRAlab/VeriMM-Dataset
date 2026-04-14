module top_module(
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
    );assign Sum = Cin ^ A ^ B;
    assign Cout = (Cin & (A ^ B)) | (A & B);
endmodule