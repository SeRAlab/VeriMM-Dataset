module d_flip_flop (
    input clk,
    input set,
    input d,
    output reg q);

    always @(posedge clk or posedge set) begin
        if (set) begin
            q <= 1'b1;
        end else begin
            q <= d;
        end
    end
endmodule