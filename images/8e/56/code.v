module top_module(
    input rst,
    input [7:0] Cambio,
    input got_data,
    input clk,
    output reg [(N-1):0] Cuenta
);parameter N = 2;
    parameter X = 2;

    always @(posedge clk) begin
        if (rst) begin
            Cuenta <= 0;
        end else if (Cambio == 8'h7A && got_data) begin
            if (Cuenta == X) begin
                Cuenta <= 0;
            end else begin
                Cuenta <= Cuenta + 1'd1;
            end
        end else if (Cambio == 8'h69 && got_data) begin
            if (Cuenta == 0) begin
                Cuenta <= X;
            end else begin
                Cuenta <= Cuenta - 1'd1;
            end
        end else begin
            Cuenta <= Cuenta;
        end
    end
endmodule