module fsm_moore(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

reg [2:0] state, next_state;

parameter IDLE = 3'b000;
parameter S0 = 3'b001;
parameter S1 = 3'b010;
parameter S2 = 3'b011;
parameter S3 = 3'b100;
parameter MATCH_STATE = 3'b101;

always @(posedge CLK or posedge RST) begin
    if (RST)
        state <= IDLE;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        IDLE: begin
            if (IN == 0)
                next_state = S0;
            else
                next_state = IDLE;
        end
        S0: begin
            if (IN == 1)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1: begin
            if (IN == 1)
                next_state = S2;
            else
                next_state = IDLE;
        end
        S2: begin
            if (IN == 0)
                next_state = MATCH_STATE;
            else
                next_state = IDLE;
        end
        MATCH_STATE: begin
            if (IN == 0)
                next_state = S0;
            else
                next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

always @(*) begin
    if (RST)
        MATCH <= 0;
    else if (state == MATCH_STATE)
        MATCH <= 1;
    else
        MATCH <= 0;
end

endmodule