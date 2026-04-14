module top_module(
    input rstCRC,
    input CRCEn,
    input [7:0] dataIn,
    input clk,
    input rst,
    output reg [15:0] CRCResult,
    output ready
);reg [3:0] i;
reg [7:0] data;
reg doUpdateCRC;

assign ready = (doUpdateCRC == 0);

always @(posedge clk) begin
    if (rst == 1'b1 || rstCRC == 1'b1) begin
        doUpdateCRC <= 1'b0;
        i <= 4'h0;
        CRCResult <= 16'hffff;
    end
    else if (doUpdateCRC == 1'b0 && CRCEn == 1'b1) begin
        doUpdateCRC <= 1'b1;
        data <= dataIn;
    end
    else if (doUpdateCRC == 1'b1) begin
        if ((CRCResult[0] ^ data[0]) == 1'b1) begin
            CRCResult <= {1'b0, CRCResult[15:1]} ^ 16'ha001;
        end
        else begin
            CRCResult <= {1'b0, CRCResult[15:1]};
        end
        data <= {1'b0, data[7:1]};
        i <= i + 1;
        if (i == 4'h7) begin
            doUpdateCRC <= 1'b0;
            i <= 4'h0;
        end
    end
end

endmodule