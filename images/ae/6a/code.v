module top_module(TRG_ONE, MODE, CLK, R, POUT);parameter [7:0] N = 8'hFF;

    input     TRG_ONE;
    input     MODE;
    input     CLK;
    input     R;
    output    POUT;

    reg [7:0] counter_reg;
    reg       pout_reg;

    always @(posedge CLK) begin
        if (R == 1'b1) begin
            pout_reg <= 1'b0;
        end
        else if (counter_reg == N-1) begin
            pout_reg <= 1'b0;
        end
        else if (TRG_ONE == 1'b1) begin
            pout_reg <= 1'b1;
        end
    end

    always @(posedge CLK) begin
        if (R == 1'b1) begin
            counter_reg <= 8'd0;
        end
        else if (counter_reg == N-1) begin
            counter_reg <= 8'd0;
        end
        else if ((MODE == 1'b1) && (TRG_ONE == 1'b1)) begin
            counter_reg <= 8'd0;
        end
        else if (pout_reg == 1'b1) begin
            counter_reg <= counter_reg + 1'b1;
        end
    end

    assign POUT = pout_reg;

endmodule