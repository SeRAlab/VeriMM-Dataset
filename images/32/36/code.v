module fixed_priority_arbiter(
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
        end else begin
            grant <= 4'b0000; // Default no grant
            if (req[3] == 1'b1)
                grant[3] <= 1'b1; // Grant request 3
            else if (req[2] == 1'b1)
                grant[2] <= 1'b1; // Grant request 2
            else if (req[1] == 1'b1)
                grant[1] <= 1'b1; // Grant request 1
            else if (req[0] == 1'b1)
                grant[0] <= 1'b1; // Grant request 0
        end
    end
endmodule