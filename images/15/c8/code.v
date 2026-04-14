module d_flip_flop (
    input wire clk,
    input wire reset,
    input wire load,
    input wire d,
    output reg q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end else if (load) begin
            q <= d;
        end else begin
            q <= q; // hold the previous value
        end
    end
endmodule