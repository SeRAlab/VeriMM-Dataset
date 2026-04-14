module top_module(
    input iCLK,
    input iRST,
    output reg [3:0] oCNT
);always @(posedge iCLK) begin
    if (iRST) begin
        oCNT <= 4'b0; // Reset to 0
    end else begin
        oCNT <= oCNT + 1; // Increment count
    end
end

endmodule