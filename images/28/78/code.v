module round_robin_arbiter(
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] grant
);
    reg [1:0] current_grant;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
            current_grant <= 2'b00;
        end else begin
            grant <= 4'b0000; // Reset grant
            if (req != 4'b0000) begin
                // Grant the current requestor
                grant[current_grant] <= 1'b1;
                // Move to the next requestor
                current_grant <= (current_grant + 1) % 4;
            end
        end
    end
endmodule