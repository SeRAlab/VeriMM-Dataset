module updown_counter (
    input clk,
    input U_D,
    output reg [3:0] Q
);

    always @(posedge clk) begin
        if (U_D == 1'b1) begin
            Q <= Q + 1;
        end
        else begin
            Q <= Q - 1;
        end
    end

endmodule