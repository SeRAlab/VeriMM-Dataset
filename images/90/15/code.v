module top_module(
    input clock,
    input reset,
    input J,
    input K,
    output reg Q,
    output reg Qbar
);always @(posedge clock)
begin
    if (reset)
    begin
        Q <= 0;
        Qbar <= 1;
    end
    else if (J & ~K)
    begin
        Q <= 1;
        Qbar <= 0;
    end
    else if (~J & K)
    begin
        Q <= 0;
        Qbar <= 1;
    end
    else if (J & K)
    begin
        Q <= ~Q;
        Qbar <= ~Qbar;
    end
end

endmodule