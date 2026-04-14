module fsm_moore_1001(IN, MATCH, CLK, RST);
input [1:0] IN;
input CLK, RST;
output reg MATCH;

reg [1:0] state, next_state;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

always @(posedge CLK or posedge RST) begin
    if (RST)
        state <= S0;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        S0: begin
            if (IN == 2'b10)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (IN == 2'b01)
                next_state = S2;
            else
                next_state = S0;
        end
        S2: begin
            if (IN == 2'b10)
                next_state = S3;
            else
                next_state = S0;
        end
        S3: begin
            if (IN == 2'b01)
                next_state = S2;
            else
                next_state = S0;
        end
        default: next_state = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST)
        MATCH <= 0;
    else if (state == S3 && IN == 2'b01)
        MATCH <= 1;
    else
        MATCH <= 0;
end

endmodule