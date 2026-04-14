module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q);reg [3:0] q1, q2, q3, q4;

    always @(posedge clk) begin
        if (areset) begin
            q1 <= 4'b0;
            q2 <= 4'b0;
            q3 <= 4'b0;
            q4 <= 4'b0;
        end else begin
            if (load && ena) begin
                q1 <= data;
                q2 <= 4'b0;
                q3 <= 4'b0;
                q4 <= 4'b0;
            end else if (load) begin
                q1 <= data;
            end else if (ena) begin
                q1 <= q2;
                q2 <= q3;
                q3 <= q4;
                q4 <= 4'b0;
            end
        end
    end

    assign q = q1;

endmodule