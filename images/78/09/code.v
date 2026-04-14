module top_module(
    input D,
    input nCLK,
    input nRST,
    input INIT,
    output reg Q
);always @(posedge nCLK) begin
        if (!nRST) begin
            Q <= INIT;
        end else begin
            Q <= D;
        end
    end

endmodule