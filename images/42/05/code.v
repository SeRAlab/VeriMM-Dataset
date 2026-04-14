module top_module( input A, input B, output YS, output YC );assign YS = A ^ B;
    assign YC = A & B;endmodule