module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
        end else begin
            case (req)
                4'b0001: grant <= 4'b0001; // Grant req[0]
                4'b0010: grant <= (grant[0] ? 4'b0001 : 4'b0010); // Grant req[1] if req[0] is not active
                4'b0100: grant <= (grant[0] || grant[1] ? 4'b0001 : 4'b0010) ? 4'b0001 : 4'b0100; // Grant req[2]
                4'b1000: grant <= (grant[0] || grant[1] || grant[2] ? 4'b0001 : 4'b0010) ? 4'b0001 : (grant[1] ? 4'b0010 : 4'b0100) ? 4'b0010 : 4'b1000; // Grant req[3]
                default: grant <= grant; // Maintain the current grant if nothing is high
            endcase
        end
    end
endmodule