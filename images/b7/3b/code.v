module top_module(
    input A,
    input B,
    input C,
    input invert,
    output reg out
);always @ (A, B, C, invert) begin
        if (C == 1'b0) begin
            out <= A;
        end
        else begin
            out <= B;
        end
        
        if (invert == 1'b1) begin
            out <= ~out;
        end
    end

endmodule