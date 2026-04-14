module top_module(out, a, b, e, w);output reg out; // change to reg since we will be assigning to it in always block
input a, b, e, w; // declare inputs

always @ (*)
begin
    // reset all values to 0
    out = 1'b0;

    // check each input combination and set the output and corresponding values of a and b
    if (~a && ~b && ~e && ~w)
    begin
        out = 1'b1;
    end 

    if (~a && ~b && ~e && w)
    begin
        out = 1'b1;
    end

    if (~a && ~b && e && ~w)
    begin
        out = 1'b1;
    end

    if (~a && ~b && e && w)
    begin
        out = 1'b1;
    end

    if (~a && b && ~e && ~w)
    begin
        out = 1'b0;
    end

    if (~a && b && ~e && w)
    begin
        out = 1'b0;
    end

    if (~a && b && e && ~w)
    begin
        out = 1'b0;
    end

    if (~a && b && e && w)
    begin
        out = 1'b0;
    end

    if (a && ~b && ~e && ~w)
    begin
        out = 1'b0;
    end

    if (a && ~b && ~e && w)
    begin
        out = 1'b0;
    end

    if (a && ~b && e && ~w)
    begin
        out = 1'b0;
    end

    if (a && ~b && e && w)
    begin
        out = 1'b0;
    end

    if (a && b && ~e && ~w)
    begin
        out = 1'b0;
    end

    if (a && b && ~e && w)
    begin
        out = 1'b0;
    end

    if (a && b && e && ~w)
    begin
        out = 1'b0;
    end

    if (a && b && e && w)
    begin
        out = 1'b0;
    end
end

endmodule