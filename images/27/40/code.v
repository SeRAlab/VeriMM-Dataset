module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    input wire req2,
    output reg [1:0] grant // 00 = R0, 01 = R1, 10 = R2
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        grant <= 2'b00; // Default to no grant
    end else begin
        if (req0) begin
            grant <= 2'b00; // Grant to R0
        end else if (req1) begin
            grant <= 2'b01; // Grant to R1
        end else if (req2) begin
            grant <= 2'b10; // Grant to R2
        end else begin
            grant <= 2'b00; // Default to no grant
        end
    end
end

endmodule