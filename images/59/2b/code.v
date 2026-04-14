module top_module(
    input clk,
    input reset,
    input set,
    input d,
    output reg q,
    output reg q_n
);always @(posedge clk or negedge reset or negedge set) begin
        if (!reset) begin
            q <= 1'b0;
            q_n <= 1'b1;
        end
        else if (!set) begin
            q <= 1'b1;
            q_n <= 1'b0;
        end
        else begin
            q <= d;
            q_n <= ~d;
        end
    end

endmodule