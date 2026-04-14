module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire en,
    input wire [2:0] req,
    output reg [2:0] grant
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 3'b000;
        end else if (en) begin
            grant <= 3'b000; // Default no grant
            if (req[0]) begin
                grant[0] <= 1'b1; // Grant to req[0]
            end else if (req[1]) begin
                grant[1] <= 1'b1; // Grant to req[1]
            end else if (req[2]) begin
                grant[2] <= 1'b1; // Grant to req[2]
            end
        end
    end
endmodule