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
        grant <= 4'b0000; // Reset grant to zero
        if (req[3]) grant[3] <= 1; // Grant to highest priority
        else if (req[2]) grant[2] <= 1; // Grant to second highest
        else if (req[1]) grant[1] <= 1; // Grant to third highest
        else if (req[0]) grant[0] <= 1; // Grant to lowest
    end
end

endmodule