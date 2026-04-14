module t_flip_flop (
    input wire clk,
    input wire T,
    output reg Q
);
    always @(posedge clk) begin
        if (T) begin
            Q <= ~Q;  // Toggle
        end
    end
endmodule