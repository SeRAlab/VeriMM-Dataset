module fixed_priority_arbiter (
    input wire clk,
    input wire rst_n,
    input wire enable,
    input wire [4:0] req,
    output reg [4:0] gnt
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gnt <= 5'b00000;
        end else if (enable) begin
            gnt <= 5'b00000; // Default to no grant
            if (req[0]) gnt[0] <= 1'b1; // Grant req0
            else if (req[1]) gnt[1] <= 1'b1; // Grant req1
            else if (req[2]) gnt[2] <= 1'b1; // Grant req2
            else if (req[3]) gnt[3] <= 1'b1; // Grant req3
            else if (req[4]) gnt[4] <= 1'b1; // Grant req4
        end
    end
endmodule