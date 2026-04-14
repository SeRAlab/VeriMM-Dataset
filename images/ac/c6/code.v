module edge_detector(CLK, RST, IN, EDGE_DET);
input CLK, RST, IN;
output EDGE_DET;
reg EDGE_DET;
reg prev_IN;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        EDGE_DET <= 0;
        prev_IN <= 0;
    end else begin
        if (IN && !prev_IN)
            EDGE_DET <= 1;
        else
            EDGE_DET <= 0;
        prev_IN <= IN;
    end
end

endmodule