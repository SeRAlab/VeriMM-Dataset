module up_down_counter (
    input LOAD, RESET, DIR, CLK,
    input [3:0] D,
    output reg [3:0] Q
);

    always @(posedge CLK) begin
        if (RESET) begin
            Q <= 4'b0;
        end else if (LOAD) begin
            Q <= D;
        end else if (DIR) begin
            Q <= Q + 1;
        end else begin
            Q <= Q - 1;
        end
    end

endmodule