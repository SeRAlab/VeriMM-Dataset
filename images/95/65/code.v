module top_module(
    input wire iCLOCK,
    input wire inRESET,
    input wire iCONF_WRITE,
    input wire iCONF_ENA,
    input wire iCOUNT_WRITE,
    input wire [1:0] inCOUNT_DQM,
    input wire [63:0] iCOUNT_COUNTER,
    output wire oWORKING,
    output wire [63:0] oCOUNTER
);reg [63:0] counter_reg;
    reg working_reg;

    always @(posedge iCLOCK or negedge inRESET) begin
        if (~inRESET) begin
            counter_reg <= 0;
            working_reg <= 0;
        end else begin
            if (iCONF_WRITE) begin
                working_reg <= iCONF_ENA;
            end else if (iCOUNT_WRITE) begin
                if (inCOUNT_DQM[0]) begin
                    counter_reg[31:0] <= counter_reg[31:0];
                end else begin
                    counter_reg[31:0] <= iCOUNT_COUNTER[31:0];
                end
                if (inCOUNT_DQM[1]) begin
                    counter_reg[63:32] <= counter_reg[63:32];
                end else begin
                    counter_reg[63:32] <= iCOUNT_COUNTER[63:32];
                end
                working_reg <= 1'b1;
            end else begin
                working_reg <= 1'b1;
                counter_reg <= counter_reg + 1'b1;
            end
        end
    end

    assign oCOUNTER = counter_reg;
    assign oWORKING = working_reg;

endmodule