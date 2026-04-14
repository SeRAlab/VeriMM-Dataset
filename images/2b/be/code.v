module FixedPriorityArbiter (
    input clk,
    input rst,
    input [2:0] req,
    output reg [2:0] grant
);
    reg [2:0] last_granted;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 3'b000;
            last_granted <= 3'b000;
        end else begin
            if (req[2]) begin
                grant <= 3'b100; // Grant req[2]
                last_granted <= 3'b100;
            end else if (req[1]) begin
                grant <= 3'b010; // Grant req[1]
                last_granted <= 3'b010;
            end else if (req[0]) begin
                grant <= 3'b001; // Grant req[0]
                last_granted <= 3'b001;
            end else begin
                grant <= 3'b000; // No grant
            end
        end
    end
endmodule