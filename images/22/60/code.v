module fixed_priority_arbiter (
    input wire clk,
    input wire reset,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [1:0] grant
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        grant <= 2'b00; // No grant
    end else begin
        if (req0) grant <= 2'b00; // Grant req0
        else if (req1) grant <= 2'b01; // Grant req1
        else if (req2) grant <= 2'b10; // Grant req2
        else if (req3) grant <= 2'b11; // Grant req3
        else grant <= 2'b00; // No grant
    end
end

endmodule