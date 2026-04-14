module top_module(input D, C, R, S, output reg Q);always @(posedge C or posedge R or posedge S) begin
        if (R) begin
            Q <= 1'b0;
        end else if (S) begin
            Q <= 1'b1;
        end else begin
            Q <= D;
        end
    end
endmodule