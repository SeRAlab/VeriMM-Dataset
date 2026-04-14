module fixed_priority_arbiter (
    input wire clk,
    input wire reset,
    input wire Req1,
    input wire Req2,
    input wire Req3,
    output reg Grant1,
    output reg Grant2,
    output reg Grant3
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        Grant1 <= 0;
        Grant2 <= 0;
        Grant3 <= 0;
    end else begin
        Grant1 <= Req1 ? 1 : 0;
        Grant2 <= (Grant1 == 0 && Req2) ? 1 : 0;
        Grant3 <= (Grant1 == 0 && Grant2 == 0 && Req3) ? 1 : 0;
    end
end

endmodule