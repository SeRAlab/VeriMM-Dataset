module top_module(
    input C,
    input CE,
    input D,
    input R,
    output reg Q
);always @(posedge C or posedge R) begin
        if (R)
            Q <= 1'b0;
        else if (CE)
            Q <= D;
    end
endmodule