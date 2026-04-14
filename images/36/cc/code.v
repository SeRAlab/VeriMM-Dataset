module priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    output reg grant
);
    always @(*) begin
        if (req0) begin
            grant = 1'b1; // Grant req0
        end else if (req1) begin
            grant = 1'b1; // Grant req1
        end else if (req2) begin
            grant = 1'b1; // Grant req2
        end else begin
            grant = 1'b0; // No request
        end
    end
endmodule