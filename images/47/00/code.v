module top_module(
    input clk,
    input reset,
    input N,
    input D,
    input Q,
    output reg vend,
    output reg change
);parameter STATE0 = 2'b00, STATE1 = 2'b01, STATE2 = 2'b10;

    reg [1:0] state = STATE0;
    reg [1:0] next_state;
    reg [1:0] change_state;
    reg [1:0] change_next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE0;
            change_state <= STATE0;
        end
        else begin
            state <= next_state;
            change_state <= change_next_state;
        end
    end

    always @(*) begin
        case (state)
            STATE0: begin
                if (Q) begin
                    next_state = STATE1;
                    vend = 0;
                    change = 0;
                end
                else begin
                    next_state = STATE0;
                    vend = 0;
                    change = 0;
                end
            end
            STATE1: begin
                if (Q) begin
                    next_state = STATE1;
                    vend = 1;
                    change = 0;
                end
                else if (Q == 0 && (N || D)) begin
                    next_state = STATE2;
                    vend = 1;
                    change = 0;
                end
                else begin
                    next_state = STATE1;
                    vend = 0;
                    change = 0;
                end
            end
            STATE2: begin
                if (Q) begin
                    next_state = STATE1;
                    change_next_state = STATE0;
                    vend = 1;
                    change = 1;
                end
                else begin
                    next_state = STATE2;
                    change_next_state = STATE2;
                    vend = 0;
                    change = 1;
                end
            end
        endcase
    end

endmodule