module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    input wire req2,
    output reg [1:0] grant
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 2'b00; // No request granted
        end else begin
            if (req0) begin
                grant <= 2'b00; // Grant req0
            end else if (req1) begin
                grant <= 2'b01; // Grant req1
            end else if (req2) begin
                grant <= 2'b10; // Grant req2
            end else begin
                grant <= 2'b00; // No request granted
            end
        end
    end

endmodule