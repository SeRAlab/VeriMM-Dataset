module fixed_priority_arbiter(
    input wire clk,
    input wire rst_n,
    input wire [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            grant <= 4'b0000; // Reset all grants to 0
        end else begin
            case (req)
                4'b0001: grant <= 4'b0001; // Grant req[0]
                4'b0010: grant <= (grant == 4'b0000) ? 4'b0010 : grant; // Grant req[1] if no higher priority
                4'b0100: grant <= (grant == 4'b0000) ? 4'b0100 : grant; // Grant req[2] if no higher priority
                4'b1000: grant <= (grant == 4'b0000) ? 4'b1000 : grant; // Grant req[3] if no higher priority
                default: grant <= 4'b0000; // No grant if no requests
            endcase
        end
    end
endmodule