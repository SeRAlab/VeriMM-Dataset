module round_robin_arbiter(
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] grant
);
    reg [1:0] next_grant;
    reg [1:0] curr_grant;

    // Grant logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
            curr_grant <= 2'b00;
        end else begin
            if (req[curr_grant]) begin
                grant <= 4'b0000;
                grant[curr_grant] <= 1'b1;  // Grant to current request
            end else begin
                // Find next grant
                if (curr_grant == 2'b11)
                    curr_grant <= 2'b00;
                else
                    curr_grant <= curr_grant + 1;
                    
                // Grant to the next available request
                grant <= 4'b0000;
                if (req[curr_grant])
                    grant[curr_grant] <= 1'b1;
                else if (req[(curr_grant + 1) % 4])
                    grant[(curr_grant + 1) % 4] <= 1'b1;
                else if (req[(curr_grant + 2) % 4])
                    grant[(curr_grant + 2) % 4] <= 1'b1;
                else if (req[(curr_grant + 3) % 4])
                    grant[(curr_grant + 3) % 4] <= 1'b1;
            end
        end
    end
endmodule