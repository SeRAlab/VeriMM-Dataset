module fixed_priority_arbiter(
    input wire clk,
    input wire reset,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [3:0] grant
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        grant <= 4'b0000;
    end else begin
        grant <= 4'b0000; // Default: no grant
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