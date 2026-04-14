module top_module(
    input clk,
    input n_reset,
    input button_in,
    output reg DB_out
);parameter N = 11; // debounce time = 32 ms

    reg [N-1:0] q_reg;
    reg [N-1:0] q_next;
    reg DFF1, DFF2;
    wire q_add;
    wire q_reset;

    assign q_reset = (DFF1 ^ DFF2);
    assign q_add = ~(q_reg[N-1]);

    always @ (q_reset, q_add, q_reg) begin
        case ({q_reset, q_add})
            2'b00: q_next <= q_reg;
            2'b01: q_next <= q_reg + ({{(N-1){1'b0}}, 1'b1});
            default: q_next <= {N{1'b0}};
        endcase
    end

    always @(posedge clk) begin
        if (n_reset == 1'b0) begin
            DFF1 <= 1'b0;
            DFF2 <= 1'b0;
            q_reg <= {N{1'b0}};
        end else begin
            DFF1 <= button_in;
            DFF2 <= DFF1;
            q_reg <= q_next;
        end
    end

    always @(posedge clk) begin
        if (q_reg[N-1] == 1'b1) begin
            DB_out <= DFF2;
        end
    end

endmodule