module fixed_priority_arbiter(
    input clk,
    input rst,
    input req0,
    input req1,
    input req2,
    input req3,
    output reg grant
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 0;
        end else begin
            if (req0) begin
                grant <= 1;
            end else if (req1) begin
                grant <= 1;
            end else if (req2) begin
                grant <= 1;
            end else if (req3) begin
                grant <= 1;
            end else begin
                grant <= 0;
            end
        end
    end
endmodule