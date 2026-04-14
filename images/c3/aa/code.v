module my_register (
    input clk,
    input ena,
    input d,
    input clrn,
    input prn,
    output reg q
);

    always @(posedge clk) begin
        if (clrn == 1'b0) // clear
            q <= 1'b0;
        else if (prn == 1'b0) // preset
            q <= 1'b1;
        else if (ena == 1'b1) // enable
            q <= d;
    end

endmodule