module top_module(
    input iCLK,
    input iRST,
    input [15:0] iData,
    output reg [15:0] oEncData
);reg [7:0] A, B, C;
reg [15:0] D, E;

always @(posedge iCLK) begin
    if (iRST) begin
        oEncData <= 16'h0000;
    end else begin
        A <= iData[7:0];
        B <= iData[15:8];
        C <= A ^ B;
        D <= C * 3;
        E <= {D[15:8], C[7:0]} + {C[15:8], D[7:0]};
        oEncData <= E ^ iData;
    end
end

endmodule