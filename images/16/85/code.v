module round_robin_arbiter (
    input wire clk,
    input wire reset,
    input wire [3:0] req,
    output reg [3:0] grant
);
    reg [1:0] last_grant;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
            last_grant <= 2'b00;
        end else begin
            last_grant <= (last_grant + 1) % 4; // Round-robin logic
            grant <= 4'b0000; // Reset grant
            if (req[last_grant]) begin
                grant[last_grant] <= 1'b1; // Grant to the first valid request found
            end else begin
                // Search for the next valid request
                grant[last_grant] <= req[last_grant];
            end
        end
    end
endmodule