module fixed_priority_arbiter(
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] grant
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        grant <= 4'b0000;
    end else begin
        grant <= 4'b0000; // Reset grant
        if (req[0]) grant <= 4'b0001; // Grant req[0]
        else if (req[1]) grant <= 4'b0010; // Grant req[1]
        else if (req[2]) grant <= 4'b0100; // Grant req[2]
        else if (req[3]) grant <= 4'b1000; // Grant req[3]
    end
end

endmodule