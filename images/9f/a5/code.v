module top_module(
    input clk,
    input nrst,
    input start,
    input [63:0] log_lambda_up,
    input [63:0] log_lambda_down,
    input [63:0] K_over_S,
    output reg [63:0] v_ex,
    output reg [12:0] wraddr,
    output reg wren
);reg [127:0] tmp;

    always @(posedge clk) begin
        if (nrst) begin
            v_ex <= 0;
            wraddr <= 0;
            wren <= 0;
        end else begin
            if (start) begin
                tmp <= log_lambda_up - log_lambda_down;
                tmp <= tmp * K_over_S;
                v_ex <= tmp[63:0];
                wraddr <= 13'h123;
                wren <= 1;
            end
        end
    end

endmodule