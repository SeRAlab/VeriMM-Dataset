module addsub4bit(
    input [3:0] A,
    input [3:0] B,
    input S,
    input C,
    output [3:0] F,
    output C_out
);

reg [3:0] temp;

always @ (*)
begin
    if(S == 1) // subtraction
    begin
        temp = A - B;
        if(C == 1) temp = temp - 1;
        F = temp;
        C_out = (temp[3] == 1) ? 0 : 1;
    end
    else // addition
    begin
        temp = A + B;
        if(C == 1) temp = temp + 1;
        F = temp;
        C_out = (temp[4] == 1) ? 1 : 0;
    end
end

endmodule