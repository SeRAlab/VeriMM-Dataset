module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    input wire req2,
    output reg grant
);

reg [1:0] last_grant;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        grant <= 0;
        last_grant <= 2'b00; // No request granted
    end else begin
        if (req0) begin
            grant <= 1'b1; // Grant req0
            last_grant <= 2'b00;
        end else if (req1 && last_grant != 2'b00) begin
            grant <= 1'b1; // Grant req1 if last was not req0
            last_grant <= 2'b01;
        end else if (req2 && last_grant == 2'b01) begin
            grant <= 1'b1; // Grant req2 if last was req1
            last_grant <= 2'b10;
        end else begin
            grant <= 1'b0; // No grant
        end
    end
end

endmodule