module fixed_priority_arbiter (
    input clk,
    input rst,
    input [2:0] req,
    output reg [2:0] grant
);
    reg [2:0] grant_next;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 3'b000;
        end else begin
            grant <= grant_next;
        end
    end

    always @(*) begin
        grant_next = 3'b000; // Default no grant
        if (req[2]) begin
            grant_next = 3'b100; // Grant req[2]
        end else if (req[1]) begin
            grant_next = 3'b010; // Grant req[1]
        end else if (req[0]) begin
            grant_next = 3'b001; // Grant req[0]
        end
    end
endmodule