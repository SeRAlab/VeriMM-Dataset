module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire Req0,
    input wire Req1,
    input wire Req2,
    input wire Req3,
    output reg [3:0] Grant,
    output reg Valid
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Grant <= 4'b0000;
            Valid <= 0;
        end else begin
            Valid <= 1; 
            if (Req0) begin
                Grant <= 4'b0001; // Grant Req0
            end else if (Req1) begin
                Grant <= 4'b0010; // Grant Req1
            end else if (Req2) begin
                Grant <= 4'b0100; // Grant Req2
            end else if (Req3) begin
                Grant <= 4'b1000; // Grant Req3
            end else begin
                Grant <= 4'b0000; // No grants
                Valid <= 0; // No valid output
            end
        end
    end
endmodule