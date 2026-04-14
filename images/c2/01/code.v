module up_counter_sync_clr (
    input  wire        clk,
    input  wire        clr,
    output reg  [3:0]  Q
);

    always @(posedge clk) begin
        if (clr) begin
            Q <= 4'b0000;
        end else begin
            Q <= Q + 1;
        end
    end

endmodule