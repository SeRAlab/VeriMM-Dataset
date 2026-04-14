module fixed_priority_arbiter (
    input wire clk,
    input wire reset,
    input wire req0,
    input wire req1,
    input wire req2,
    output reg [1:0] grant // 00: None, 01: req0, 10: req1, 11: req2
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 2'b00; // No grant
        end else begin
            if (req0) begin
                grant <= 2'b01; // Grant req0
            end else if (req1) begin
                grant <= 2'b10; // Grant req1
            end else if (req2) begin
                grant <= 2'b11; // Grant req2
            end else begin
                grant <= 2'b00; // No grant
            end
        end
    end
endmodule