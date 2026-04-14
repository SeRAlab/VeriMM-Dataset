module top_module(
    input signed [1:0] dividend,
    input signed [1:0] divisor,
    output reg signed [1:0] quotient,
    output reg signed [1:0] remainder
);reg signed [3:0] A, Q, M, count;
reg [1:0] state;

always @(*) begin
    case(state)
        2'b00: begin // initialization
            A = {dividend, 2'b00};
            Q = {2'b0, divisor};
            M = {2'b0, -divisor};
            count = 2;
            state = 2'b01;
        end
        2'b01: begin // shift left
            if(count == 0)
                state = 2'b10;
            else begin
                Q = {Q[1:0], A[3]};
                A = {A[2:0], 1'b0};
                count = count - 1;
            end
        end
        2'b10: begin // subtract
            if(A[3:2] >= M[3:2]) begin
                A = A + M;
                Q = {Q[1:0], 1'b0};
            end else begin
                Q = {Q[1:0], 1'b1};
            end
            state = 2'b01;
        end
        default: state = 2'b00;
    endcase
end

assign quotient = Q[1:0];
assign remainder = A[1:0];

endmodule