module top_module( input A, input B, input C, output YS, output YC );assign YS = (A ^ B) ^ C;
    assign YC = (A & B) | (B & C) | (A & C);endmodule