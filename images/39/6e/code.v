module fixed_priority_arbiter(
    input wire clk,
    input wire rst,
    input wire [4:0] req,  // 5 request lines
    output reg [4:0] grant  // 5 grant lines
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 5'b00000;  // Reset grant lines
        end else begin
            grant <= 5'b00000;  // Clear grants
            if (req[0]) grant[0] <= 1;  // Grant to req[0] if requested
            else if (req[1]) grant[1] <= 1;  // Grant to req[1] if requested
            else if (req[2]) grant[2] <= 1;  // Grant to req[2] if requested
            else if (req[3]) grant[3] <= 1;  // Grant to req[3] if requested
            else if (req[4]) grant[4] <= 1;  // Grant to req[4] if requested
        end
    end
endmodule