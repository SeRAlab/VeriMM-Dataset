module binary_counter_cout(
    input clk,
    input reset,
    output reg cout,
    output reg [2:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
            cout <= 0;
        end else if (q == 3'b111) begin
            q <= 0;
            cout <= 1;
        end else begin
            q <= q + 1;
            cout <= 0;
        end
    end

endmodule