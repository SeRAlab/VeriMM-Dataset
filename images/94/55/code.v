module top_module(
    input clk, rst, mfmIn, mfmEdge,
    output reg currentRealBit,
    output reg currentRealBitValid
);reg [1:0] state;
wire mfmInPrev;

assign mfmInPrev = mfmIn;

always @(posedge clk) begin
    if (rst) begin
        state <= 2'b00;
        currentRealBit <= 1'b0;
        currentRealBitValid <= 1'b0;
    end else begin
        case (state)
            2'b00: begin
                if (mfmEdge) begin
                    state <= 2'b01;
                    currentRealBit <= mfmIn;
                    currentRealBitValid <= 1'b0;
                end
            end
            2'b01: begin
                if (mfmEdge) begin
                    state <= 2'b10;
                    currentRealBitValid <= mfmInPrev & ~mfmIn;
                end
            end
            2'b10: begin
                if (mfmEdge) begin
                    state <= 2'b01;
                    currentRealBit <= mfmIn;
                end
            end
        endcase
    end
end

endmodule