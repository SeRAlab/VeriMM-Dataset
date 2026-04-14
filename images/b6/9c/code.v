module top_module(
    input [7:0] dac_in,
    input clk,
    input rst,
    input conv,
    output reg [6:0] dac_out
);parameter RES = 7;
    parameter MAX_DAC_VAL = (2**RES)-1;
    parameter V_REF = 3.3;
    parameter V_STEP = V_REF/MAX_DAC_VAL;
    
    reg [7:0] dac_reg;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            dac_reg <= 8'b0;
        end else if (conv) begin
            dac_reg <= dac_in;
        end
    end
    
    always @(posedge clk) begin
        // Simplify the output to ensure it is a valid part select
        dac_out <= dac_reg[6:0]; // taking the 7 LSBs of dac_reg
    end

endmodule