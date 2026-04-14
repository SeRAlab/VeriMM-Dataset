module fsm_mealy_010(IN, MATCH, CLK, RST);
input IN, CLK, RST;
output reg MATCH;

reg [1:0] ST_cr, ST_nt;

parameter s0 = 2'b00;
parameter s1 = 2'b01;
parameter s2 = 2'b10;

always @(posedge CLK or posedge RST) begin
    if (RST)
        ST_cr <= s0;
    else
        ST_cr <= ST_nt;
end

always @(*) begin
    case (ST_cr)
        s0: begin
            if (IN == 0)
                ST_nt = s1;
            else
                ST_nt = s0;
        end
        s1: begin
            if (IN == 1)
                ST_nt = s2;
            else
                ST_nt = s0;
        end
        s2: begin
            if (IN == 0)
                ST_nt = s1;
            else
                ST_nt = s0;
        end
        default: ST_nt = s0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST)
        MATCH <= 0;
    else if (ST_cr == s2 && IN == 0)
        MATCH <= 1;
    else
        MATCH <= 0;
end

endmodule