module top_module(
    input STARTPULSE,
    output reg DTROUT7, DTROUT6, DTROUT5, DTROUT4, DTROUT3, DTROUT2, DTROUT1, DTROUT0
);reg [2:0] counter;

always @(posedge STARTPULSE) begin
    counter <= counter + 1;
    // Reset outputs to 0 before setting the corresponding output high
    {DTROUT7, DTROUT6, DTROUT5, DTROUT4, DTROUT3, DTROUT2, DTROUT1, DTROUT0} <= 8'b0;

    if (counter == 3) begin
        DTROUT7 <= 1;
    end else if (counter == 2) begin
        DTROUT6 <= 1;
    end else if (counter == 1) begin
        DTROUT5 <= 1;
    end else if (counter == 0) begin
        DTROUT4 <= 1;
        DTROUT3 <= 1;
        DTROUT2 <= 1;
        DTROUT1 <= 1;
        DTROUT0 <= 1;
    end
end

endmodule