module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg grant
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        grant <= 0;
    end else begin
        if (req0) begin
            grant <= 1;
        end else if (req1) begin
            grant <= 2;
        end else if (req2) begin
            grant <= 3;
        end else if (req3) begin
            grant <= 4;
        end else begin
            grant <= 0;
        end
    end
end

endmodule