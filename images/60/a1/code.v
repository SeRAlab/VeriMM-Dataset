module top_module(
    input CLK,
    input [3:0] P,
    input SI,
    input PL,
    input CTRL,
    output reg [3:0] Q
);reg [3:0] Q1, Q2, Q3, Q4;

always @(posedge CLK) begin
    if (PL) begin
        Q1 <= P[0];
        Q2 <= P[1];
        Q3 <= P[2];
        Q4 <= P[3];
    end
    else begin
        if (CTRL) begin
            Q1 <= Q2;
            Q2 <= Q3;
            Q3 <= Q4;
            Q4 <= SI;
        end
        else begin
            Q4 <= Q3;
            Q3 <= Q2;
            Q2 <= Q1;
            Q1 <= SI;
        end
    end
end

assign Q = {Q4, Q3, Q2, Q1};

endmodule