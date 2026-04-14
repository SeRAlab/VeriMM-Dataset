module round_robin_arbiter (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [1:0] grant
);
    reg [1:0] current_grant;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_grant <= 2'b00;
            grant <= 2'b00;
        end else begin
            if (req0 && current_grant == 2'b00) begin
                grant <= 2'b00;
            end else if (req1 && current_grant == 2'b01) begin
                grant <= 2'b01;
            end else if (req2 && current_grant == 2'b10) begin
                grant <= 2'b10;
            end else if (req3 && current_grant == 2'b11) begin
                grant <= 2'b11;
            end else begin
                grant <= 2'b00; // Default grant to first if no req matches
            end

            current_grant <= (current_grant + 1) % 4; // Cycle through requestors
        end
    end
endmodule