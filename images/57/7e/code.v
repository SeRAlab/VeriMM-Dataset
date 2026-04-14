module top_module(
    input clk,
    input [15:0] din,
    input new_data_rdy,
    output reg [27:0] dout,
    output reg output_data_ready
);parameter WIDTH = 5'b10000;

// Coefficients
parameter COEF0_d = -12;
parameter COEF1_d = -77;
parameter COEF2_d = -148;
parameter COEF3_d = 0;
parameter COEF4_d = 148;
parameter COEF5_d = 77;
parameter COEF6_d = 12;

reg [15:0] n_delay_reg1;
reg [15:0] n_delay_reg2;
reg [15:0] n_delay_reg3;
reg [15:0] n_delay_reg4;
reg [15:0] n_delay_reg5;
reg [15:0] n_delay_reg6;

always @(posedge clk) begin
    if (new_data_rdy) begin
        n_delay_reg6 <= n_delay_reg5;
        n_delay_reg5 <= n_delay_reg4;
        n_delay_reg4 <= n_delay_reg3;
        n_delay_reg3 <= n_delay_reg2;
        n_delay_reg2 <= n_delay_reg1;
        n_delay_reg1 <= din;
        
        output_data_ready <= 1'b1;
        
        dout <= (din * COEF0_d) +
                (n_delay_reg1 * COEF1_d) +
                (n_delay_reg2 * COEF2_d) +
                (n_delay_reg3 * COEF3_d) +
                (n_delay_reg4 * COEF4_d) +
                (n_delay_reg5 * COEF5_d) +
                (n_delay_reg6 * COEF6_d);
    end else begin
        output_data_ready <= 1'b0;
    end
end

endmodule