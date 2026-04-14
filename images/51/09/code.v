module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q);reg [3:0] q1, q2, q3, q4;

    always @(posedge clk or negedge areset) begin
        if (areset == 0) begin
            q1 <= 4'b0;
            q2 <= 4'b0;
            q3 <= 4'b0;
            q4 <= 4'b0;
        end else if (load) begin
            q1 <= data;
            q2 <= q1;
            q3 <= q2;
            q4 <= q3;
        end else if (ena) begin
            q1 <= q4;
            q2 <= q1;
            q3 <= q2;
            q4 <= q3;
        end
    end

    assign q = q4;

endmodule