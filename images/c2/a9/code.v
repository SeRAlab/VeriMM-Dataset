module and_gate (
    input A,
    input B,
    input clk,
    input reset,
    output reg X
);

    always @(posedge clk) begin
        if (reset) begin
            X <= 0;
        end else begin
            X <= A & B;
        end
    end

endmodule