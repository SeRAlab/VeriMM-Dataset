module top_module(input A, B, CI, output CO, S, input VDD, VSS);assign S = A ^ B ^ CI;
    assign CO = (A & B) | (CI & (A ^ B));
    
endmodule