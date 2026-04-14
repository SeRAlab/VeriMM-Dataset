module fixed_priority_arbiter(
    input wire clk,
    input wire rst_n,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [1:0] grant
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            grant <= 2'b00; // Default to no grant
        end else begin
            if (req0) begin
                grant <= 2'b00; // Grant req0
            end else if (req1) begin
                grant <= 2'b01; // Grant req1
            end else if (req2) begin
                grant <= 2'b10; // Grant req2
            end else if (req3) begin
                grant <= 2'b11; // Grant req3
            end else begin
                grant <= 2'b00; // Default to no grant
            end
        end
    end
endmodule