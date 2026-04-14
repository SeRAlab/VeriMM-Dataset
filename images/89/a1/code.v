module top_module(
    input clk,
    input reset,
    input set,
    input d,
    output reg q);

    always @(posedge clk or posedge reset or posedge set) begin
        if (set) begin
            q <= 1'b1;
        end else if (reset) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end

endmodule