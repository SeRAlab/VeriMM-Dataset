module priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg granted,
    output reg [1:0] grant_id
);
    always @(*) begin
        if (req0) begin
            granted = 1;
            grant_id = 2'b00;
        end else if (req1) begin
            granted = 1;
            grant_id = 2'b01;
        end else if (req2) begin
            granted = 1;
            grant_id = 2'b10;
        end else if (req3) begin
            granted = 1;
            grant_id = 2'b11;
        end else begin
            granted = 0;
            grant_id = 2'b00; // Default when no requests are active
        end
    end
endmodule