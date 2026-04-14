module top_module(CB, ENABLE, D, OUT, CLOCK_50);input ENABLE, CB, CLOCK_50;
    input[11:0] D;
    output OUT;
    reg[11:0] s;

    always @(posedge CLOCK_50)
    begin
        if (CB == 1'b0)
            s = D;
        else if (ENABLE == 1'b1)
            s = s  << 1;
    end
    assign out = s[11];endmodule