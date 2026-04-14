module top_module(
    CLOCK,
    RESET,
    x,
    y,
    DIFF
);input CLOCK, RESET;
    input [11:0] x, y;
    output reg [11:0] DIFF;
    
    always @ (posedge CLOCK or posedge RESET) begin
        if (RESET) begin
            DIFF <= 0;
        end else begin
            DIFF <= (x > y) ? x - y : y - x;
        end
    end

endmodule