module fixed_priority_arbiter (
    input wire clk,
    input wire en,
    input wire req0,
    input wire req1,
    input wire req2,
    output reg grant
);
    always @(posedge clk) begin
        if (en) begin
            if (req0) begin
                grant <= 1'b1; // Grant req0
            end else if (req1) begin
                grant <= 1'b1; // Grant req1
            end else if (req2) begin
                grant <= 1'b1; // Grant req2
            end else begin
                grant <= 1'b0; // No grants
            end
        end
    end
endmodule