module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg grant
);
    reg [1:0] state; // 2-bit state to keep track of the selected request

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 0;
            state <= 2'b00;
        end else begin
            if (req0) begin
                grant <= 1; // Grant to req0
                state <= 2'b00;
            end else if (req1 && !req0) begin
                grant <= 1; // Grant to req1
                state <= 2'b01;
            end else if (req2 && !req0 && !req1) begin
                grant <= 1; // Grant to req2
                state <= 2'b10;
            end else if (req3 && !req0 && !req1 && !req2) begin
                grant <= 1; // Grant to req3
                state <= 2'b11;
            end else begin
                grant <= 0; // No grant
            end
        end
    end
endmodule