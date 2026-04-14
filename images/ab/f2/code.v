module top_module(
    input A, B, CI,
    output reg SUM, COUT
);always @ (A or B or CI) begin
        // Calculate the sum
        SUM = A ^ B ^ CI;
        
        // Calculate the carry out
        COUT = (A & B) | (CI & (A ^ B));
    end

endmodule