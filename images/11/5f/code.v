module fixed_priority_arbiter (
    input wire clk,
    input wire rst_n,
    input wire [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            grant <= 4'b0000;
        end else begin
            grant <= 4'b0000; // Default to no grant
            if (req[0]) grant[0] <= 1; // Highest priority
            else if (req[1]) grant[1] <= 1;
            else if (req[2]) grant[2] <= 1;
            else if (req[3]) grant[3] <= 1;
        end
    end
endmodule