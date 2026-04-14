module hazard_detector (
    input wire a,
    input wire b,
    input wire clk,
    output reg out
);
    reg prev_a, prev_b;

    always @(posedge clk) begin
        prev_a <= a;
        prev_b <= b;
    end

    always @(*) begin
        if (a !== prev_a || b !== prev_b) begin
            out <= out; // Hold the output
        end else begin
            out <= a & b; // Normal operation
        end
    end
endmodule