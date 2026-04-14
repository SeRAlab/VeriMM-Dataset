module SR_FF (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qbar
);
    always @(posedge clk) begin
        if (S && !R) begin
            Q <= 1'b1;
        end else if (!S && R) begin
            Q <= 1'b0;
        end
        // If both S and R are 0, retain the current state
        // If both S and R are 1, the state is indeterminate
    end

    always @* begin
        Qbar = ~Q;
    end
endmodule