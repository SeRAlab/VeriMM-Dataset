module binary_counter(
    input iCLK,
    input iRST,
    output reg [3:0] oCOUNT
);

    always @(posedge iCLK) begin
        if (iRST) begin
            oCOUNT <= 4'b0000;
        end else begin
            oCOUNT <= oCOUNT + 1;
        end
    end

endmodule