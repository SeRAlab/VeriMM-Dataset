module top_module(
    output reg y,
    input x,
    input rst_n,
    input clk);parameter S0=0;
    parameter S1=1;
    parameter S2=2;

    reg [1:0] state, next_state;

    always @(posedge clk)
        if(!rst_n) begin
            state <= S0;
        end
        else begin
            state <= next_state;
        end
            
    always @(*) begin
        next_state=S0;
        y='b0;
        case(state)
            S0: begin
                next_state = x?S1:S0;
                y=1'b0;
            end
            S1: begin
                next_state = S2;
                y=1'b0;
            end
            S2: begin
                next_state = x?S0:S1;
                y=1'b1;
            end
            default: begin
                next_state = S0;
                y='b0;
            end
        endcase
    end
endmodule