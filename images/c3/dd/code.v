module arriaiigz_ena_reg (
    input clk,
    input ena,
    input d,
    input clrn,
    input prn,
    output reg q
);

    always @(posedge clk) begin
        if (clrn == 1'b0) begin
            q <= 1'b0;
        end else if (prn == 1'b0) begin
            q <= 1'b1;
        end else if (ena == 1'b1) begin
            q <= d;
        end
    end

endmodule