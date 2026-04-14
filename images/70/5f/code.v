module top_module(
    input clk,
    input rst,
    input signed [7:0] a,
    input signed [7:0] b,
    output reg signed [15:0] p
);reg signed [7:0] a_reg;
    reg signed [7:0] b_reg;
    reg signed [15:0] p_reg;
    reg [3:0] count;
    reg [1:0] state;
    wire [8:0] m;
    wire m_sign;
    
    assign m = {a_reg, 1'b0} + (m_sign ? -b_reg : b_reg);
    assign m_sign = (m[8] == 1);
    
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
            p_reg <= 0;
            count <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    a_reg <= a;
                    b_reg <= b;
                    p_reg <= 0;
                    count <= 0;
                    state <= 1;
                end
                1: begin
                    if (count == 3) begin
                        state <= 2;
                    end else begin
                        count <= count + 1;
                        state <= 1;
                    end
                end
                2: begin
                    if (m_sign) begin
                        p_reg <= p_reg - m;
                    end else begin
                        p_reg <= p_reg + m;
                    end
                    state <= 3;
                end
                3: begin
                    p <= p_reg[15:0];
                    state <= 4;
                end
                4: begin
                    state <= 4;
                end
            endcase
        end
    end
endmodule