module top_module(clk_in, reset_in, writeEnableR0_in, writeEnableR1_in, writeValueR0_in, writeValueR1_in,
               readSelectA_in, readSelectB_in, readResultA_out, readResultB_out);parameter REG_WIDTH = 8;

    parameter CONST0_VALUE = 8'd0;
    parameter CONST1_VALUE = 8'd1;
    parameter CONST2_VALUE = 8'd31;
    parameter CONST3_VALUE = 8'd158;
    parameter CONST4_VALUE = 8'd127;
    parameter CONST5_VALUE = 8'd255;

    input clk_in, reset_in;
    input writeEnableR0_in, writeEnableR1_in;
    input [REG_WIDTH-1:0] writeValueR0_in, writeValueR1_in;
    input [2:0] readSelectA_in, readSelectB_in;
    output reg [REG_WIDTH-1:0] readResultA_out, readResultB_out;

    reg [REG_WIDTH-1:0] reg0, reg1;

    always @(readSelectA_in, readSelectB_in, reg0, reg1) begin
        case (readSelectA_in)
            3'b000: readResultA_out = reg0;
            3'b001: readResultA_out = reg1;
            3'b010: readResultA_out = CONST0_VALUE;
            3'b011: readResultA_out = CONST1_VALUE;
            3'b100: readResultA_out = CONST2_VALUE;
            3'b101: readResultA_out = CONST3_VALUE;
            3'b110: readResultA_out = CONST4_VALUE;
            3'b111: readResultA_out = CONST5_VALUE;
        endcase

        case (readSelectB_in)
            3'b000: readResultB_out = reg0;
            3'b001: readResultB_out = reg1;
            3'b010: readResultB_out = CONST0_VALUE;
            3'b011: readResultB_out = CONST1_VALUE;
            3'b100: readResultB_out = CONST2_VALUE;
            3'b101: readResultB_out = CONST3_VALUE;
            3'b110: readResultB_out = CONST4_VALUE;
            3'b111: readResultB_out = CONST5_VALUE;
        endcase
    end

    always @(posedge clk_in) begin
        if (reset_in) begin
            reg0 <= 0;
            reg1 <= 0;
        end else begin
            if (writeEnableR0_in) reg0 <= writeValueR0_in;
            if (writeEnableR1_in) reg1 <= writeValueR1_in;
        end
    end
endmodule