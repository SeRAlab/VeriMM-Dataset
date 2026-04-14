module fsm_moore_1110(IN, MATCH, CLK, RST);
input IN, CLK, RST;
output reg MATCH;

reg [2:0] state, next_state;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

always @(posedge CLK or posedge RST) begin
    if (RST)
        state <= S0;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        S0: begin
            if (IN == 1)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (IN == 1)
                next_state = S2;
            else
                next_state = S0;
        end
        S2: begin
            if (IN == 1)
                next_state = S3;
            else
                next_state = S0;
        end
        S3: begin
            if (IN == 0)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (IN == 1)
                next_state = S1;
            else
                next_state = S0;
        end
        default: next_state = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST)
        MATCH <= 0;
    else if (state == S4)
        MATCH <= 1;
    else
        MATCH <= 0;
end

endmodule