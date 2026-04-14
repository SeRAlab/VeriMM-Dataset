module top_module(
    input C,
    input D,
    input R,
    output reg Q
);always @(negedge C) begin
        if (R == 0) begin
            Q <= 0;
        end else begin
            Q <= D;
        end
    end

endmodule