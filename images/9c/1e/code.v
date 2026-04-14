module top_module(
    input CLK,
    input D,
    input SCD,
    input SCE,
    output reg Q
);always @(posedge CLK) begin
        if (SCD) begin
            Q <= 0;
        end else if (SCE) begin
            Q <= 1;
        end else begin
            Q <= D;
        end
    end

endmodule