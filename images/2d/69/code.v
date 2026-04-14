module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg grant0,
    output reg grant1,
    output reg grant2,
    output reg grant3
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        grant0 <= 0;
        grant1 <= 0;
        grant2 <= 0;
        grant3 <= 0;
    end else begin
        grant0 <= req0;
        grant1 <= req1 && !req0;
        grant2 <= req2 && !req0 && !req1;
        grant3 <= req3 && !req0 && !req1 && !req2;
    end
end

endmodule