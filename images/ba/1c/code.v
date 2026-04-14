module top_module(clk, new_data_rdy, output_data_ready, din, dout);parameter WIDTH = 16;
    parameter COEF0_7 = -9;
    parameter COEF1_7 = -56;
    parameter COEF2_7 = -109;
    parameter COEF3_7 = 0;
    parameter COEF4_7 = 109;
    parameter COEF5_7 = 56;
    parameter COEF6_7 = 9;

    input clk; 
    input new_data_rdy;
    input [WIDTH - 1:0] din; 
    output [28 - 1:0] dout; 
    output output_data_ready;
    reg output_data_ready;

    reg [WIDTH - 1:0] n_delay_reg1, n_delay_reg2, n_delay_reg3, n_delay_reg4, n_delay_reg5, n_delay_reg6, n_delay_reg7;
    reg [28 - 1:0] dout_reg;

    always @(posedge clk) begin
        if (new_data_rdy == 1'b1) begin
            n_delay_reg1 <= din;
            n_delay_reg2 <= n_delay_reg1;
            n_delay_reg3 <= n_delay_reg2;
            n_delay_reg4 <= n_delay_reg3;
            n_delay_reg5 <= n_delay_reg4;
            n_delay_reg6 <= n_delay_reg5;
            n_delay_reg7 <= n_delay_reg6;

            dout_reg <= (din * COEF0_7) + 
                (n_delay_reg1 * COEF1_7) + 
                (n_delay_reg2 * COEF2_7) + 
                (n_delay_reg3 * COEF3_7) + 
                (n_delay_reg4 * COEF4_7) + 
                (n_delay_reg5 * COEF5_7) + 
                (n_delay_reg6 * COEF6_7) + 
                (n_delay_reg7 * COEF6_7);

            output_data_ready <= 1'b1;
        end else begin
            output_data_ready <= 1'b0;
        end
    end

    assign dout = dout_reg;

endmodule