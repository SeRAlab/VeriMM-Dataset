module JK_latch (
    input J,
    input K,
    input clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (J == 0 && K == 0) begin
            // Hold state
            Q <= Q;
        end
        else if (J == 1 && K == 0) begin
            // Set state
            Q <= 1;
        end
        else if (J == 0 && K == 1) begin
            // Reset state
            Q <= 0;
        end
        else if (J == 1 && K == 1) begin
            // Toggle state
            Q <= ~Q;
        end
        Qn <= ~Q; // Complement output
    end
endmodule