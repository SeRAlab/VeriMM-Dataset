module binary_counter (
    input RST,
    output reg [3:0] Q
);

    always @(posedge clk or negedge RST) begin
        if (RST == 0) begin
            Q <= 4'b0000;
        end else begin
            Q <= Q + 1;
        end
    end

endmodule