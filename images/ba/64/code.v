module top_module(
    input clk,
    input new_data_rdy,
    input [15:0] din,
    output reg [15:0] dout,
    output reg output_data_ready
);parameter WIDTH = 16;
    parameter COEF0 = 29;
    parameter COEF1 = 101;
    parameter COEF2 = -15;
    parameter COEF3 = -235;
    parameter COEF4 = -15;
    parameter COEF5 = 101;
    parameter COEF6 = 29;

    reg [WIDTH-1:0] n_delay_reg1;
    reg [WIDTH-1:0] n_delay_reg2;
    reg [WIDTH-1:0] n_delay_reg3;
    reg [WIDTH-1:0] n_delay_reg4;
    reg [WIDTH-1:0] n_delay_reg5;
    reg [WIDTH-1:0] n_delay_reg6;

    always @(posedge clk) begin
        if (new_data_rdy) begin
            n_delay_reg1 <= din;
            n_delay_reg2 <= n_delay_reg1;
            n_delay_reg3 <= n_delay_reg2;
            n_delay_reg4 <= n_delay_reg3;
            n_delay_reg5 <= n_delay_reg4;
            n_delay_reg6 <= n_delay_reg5;

            output_data_ready <= 1'b1;
            dout <= (din * COEF0) +
                    (n_delay_reg1 * COEF1) +
                    (n_delay_reg2 * COEF2) +
                    (n_delay_reg3 * COEF3) +
                    (n_delay_reg4 * COEF4) +
                    (n_delay_reg5 * COEF5) +
                    (n_delay_reg6 * COEF6);
        end else begin
            output_data_ready <= 1'b0;
        end
    end
endmodule