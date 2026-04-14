module fixed_priority_arbiter (
    input clk,
    input rst,
    input req0,
    input req1,
    input req2,
    input req3,
    output reg [3:0] grant
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000; // No grants on reset
        end else begin
            grant <= 4'b0000; // Default no grant
            if (req0) begin
                grant <= 4'b0001; // Grant req0
            end else if (req1) begin
                grant <= 4'b0010; // Grant req1
            end else if (req2) begin
                grant <= 4'b0100; // Grant req2
            end else if (req3) begin
                grant <= 4'b1000; // Grant req3
            end
        end
    end
endmodule