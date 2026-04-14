module top_module(clk, new_data_rdy, output_data_ready, din, dout);parameter WIDTH = 16;
    parameter COEF0_c = 4;
    parameter COEF1_c = 42;
    parameter COEF2_c = 163;
    parameter COEF3_c = 255;
    parameter COEF4_c = 163;
    parameter COEF5_c = 42;
    parameter COEF6_c = 4;

    input clk;
    input new_data_rdy;
    input signed [WIDTH-1:0] din;
    output reg signed [28-1:0] dout; // Change output to reg
    output reg output_data_ready; // Change output to reg

    reg signed [WIDTH-1:0] n_delay_reg1;
    reg signed [WIDTH-1:0] n_delay_reg2;
    reg signed [WIDTH-1:0] n_delay_reg3;
    reg signed [WIDTH-1:0] n_delay_reg4;
    reg signed [WIDTH-1:0] n_delay_reg5;
    reg signed [WIDTH-1:0] n_delay_reg6;

    always @(posedge clk) begin
        if (new_data_rdy == 1'b1) begin
            n_delay_reg1 <= din;
            n_delay_reg2 <= n_delay_reg1;
            n_delay_reg3 <= n_delay_reg2;
            n_delay_reg4 <= n_delay_reg3;
            n_delay_reg5 <= n_delay_reg4;
            n_delay_reg6 <= n_delay_reg5;

            output_data_ready <= 1'b1;
            dout <= (din * COEF0_c) + 
                    (n_delay_reg1 * COEF1_c) + 
                    (n_delay_reg2 * COEF2_c) + 
                    (n_delay_reg3 * COEF3_c) + 
                    (n_delay_reg4 * COEF4_c) + 
                    (n_delay_reg5 * COEF5_c) + 
                    (n_delay_reg6 * COEF6_c);
        end else begin
            output_data_ready <= 1'b0;
        end
    end
endmodule