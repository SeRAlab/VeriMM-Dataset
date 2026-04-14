module top_module(
    input           TxClk,
    input           TxReset,
    input           Tx1,
    input           Tx0,
    output reg      D,      // Change 'output' to 'output reg'
    output reg      S       // Change 'output' to 'output reg'
);reg nextD;
    reg nextS;

    always @(posedge TxClk) begin
        if (TxReset) begin
            D <= 0;
            S <= 0;
        end
        else if (Tx0 | Tx1) begin
            D <= nextD;
            S <= nextS;
        end
    end

    assign nextD = Tx1;
    assign nextS = (Tx0 & ~(D ^ S)) | (Tx1 & (D ^ S));

endmodule